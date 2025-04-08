package main

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"

	fipb "cs426.yale.edu/lab1/failure_injection/proto"
	umc "cs426.yale.edu/lab1/user_service/mock_client"
	usl "cs426.yale.edu/lab1/user_service/server_lib"
	vmc "cs426.yale.edu/lab1/video_service/mock_client"
	vsl "cs426.yale.edu/lab1/video_service/server_lib"

	pb "cs426.yale.edu/lab1/video_rec_service/proto"
	sl "cs426.yale.edu/lab1/video_rec_service/server_lib"
	// self imports:
	// upb "cs426.yale.edu/lab1/user_service/proto"
	// vpb "cs426.yale.edu/lab1/video_service/proto"
	// "fmt"
)

func TestServerBasic(t *testing.T) {
	vrOptions := sl.VideoRecServiceOptions{
		MaxBatchSize:    50,
		DisableFallback: true,
		DisableRetry:    true,
	}
	// You can specify failure injection options here or later send
	// SetInjectionConfigRequests using these mock clients
	uClient :=
		umc.MakeMockUserServiceClient(*usl.DefaultUserServiceOptions())
	vClient :=
		vmc.MakeMockVideoServiceClient(*vsl.DefaultVideoServiceOptions())
	vrService := sl.MakeVideoRecServiceServerWithMocks(
		vrOptions,
		uClient,
		vClient,
	)

	var userId uint64 = 204054
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	out, err := vrService.GetTopVideos(
		ctx,
		&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
	)
	assert.True(t, err == nil)

	videos := out.Videos
	assert.Equal(t, 5, len(videos))
	assert.EqualValues(t, 1012, videos[0].VideoId)
	assert.Equal(t, "Harry Boehm", videos[1].Author)
	assert.EqualValues(t, 1209, videos[2].VideoId)
	assert.Equal(t, "https://video-data.localhost/blob/1309", videos[3].Url)
	assert.Equal(t, "precious here", videos[4].Title)

	ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
		Config: &fipb.InjectionConfig{
			// fail one in 1 request, i.e., always fail
			FailureRate: 1,
		},
	})

	// Since we disabled retry and fallback, we expect the VideoRecService to
	// throw an error since the VideoService is "down".
	ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	_, err = vrService.GetTopVideos(
		ctx,
		&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
	)
	assert.False(t, err == nil)
}

func TestBatching(t *testing.T) {
	t.Run("0 MaxBatchSize", func(t *testing.T) {
		max_batchsize := 0
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})

		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		var userId uint64 = 204054
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
		)
		assert.False(t, err == nil)

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err = vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("1 MaxBatchSize", func(t *testing.T) {
		max_batchsize := 1
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		var userId uint64 = 203553
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()

		out, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userId, Limit: 0},
		)
		assert.True(t, err == nil)

		// TotalRequests may consist of:
		// GetUser(): 1~2 requests
		// get_liked_videos(): ((1~2) * nbatch_users) requests where nbatch_users := int(math.Ceil(float64(len(subscribed_to))/float64(server.options.MaxBatchSize)))
		// get_video_infos(): ((1~2) * nbatch_videos) requests where nbatch_videos := int(math.Ceil(float64(len(liked_videos_all))/float64(server.options.MaxBatchSize)))

		// the following data are the output printed by the mock client functions, they serve as the reference answers
		nsubscribed_users := 55
		nliked_videos_all := 348
		nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
		nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
		min_urequests := 1 + 1*nbatch_users
		max_urequests := 2 + 2*nbatch_users
		min_vrequests := 1 * nbatch_videos
		max_vrequests := 2 * nbatch_videos

		videos := out.Videos
		assert.EqualValues(t, 1, vrService.TotalRequests)
		assert.True(t, vrService.TotalUserRequests >= uint64(min_urequests) && vrService.TotalUserRequests <= uint64(max_urequests))
		assert.True(t, vrService.TotalVideoRequests >= uint64(min_vrequests) && vrService.TotalVideoRequests <= uint64(max_vrequests))
		// assert.True(t, vrService.TotalUserRequests >= uint64(min_urequests) && vrService.TotalUserRequests <= uint64(max_urequests), fmt.Sprintf("total user requests should between %v and %v, in fact got: %v ", min_urequests, max_urequests, vrService.TotalUserRequests))
		// assert.True(t, vrService.TotalVideoRequests >= uint64(min_vrequests) && vrService.TotalVideoRequests <= uint64(max_vrequests), fmt.Sprintf("total video requests should between %v and %v, in fact got: %v ", min_vrequests, max_vrequests, vrService.TotalVideoRequests))

		// fmt.Printf("total user requests should between %v and %v, in fact got: %v ", min_urequests, max_urequests, vrService.TotalUserRequests)
		// fmt.Printf("total video requests should between %v and %v, in fact got: %v ", min_vrequests, max_vrequests, vrService.TotalVideoRequests)

		assert.Equal(t, 348, len(videos))
		assert.EqualValues(t, 1105, videos[0].VideoId)
		assert.Equal(t, "Electa Kris", videos[1].Author)
		assert.EqualValues(t, 1264, videos[2].VideoId)
		assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
		assert.Equal(t, "Tealplant: back up", videos[4].Title)

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err = vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("normal MaxBatchSize", func(t *testing.T) {
		max_batchsize := 25
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		// var userId uint64 = 203553
		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})
		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			out, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			assert.True(t, err == nil)

			nsubscribed_users := num_subscribedto_users[i]
			nliked_videos_all := num_unique_liked_videos[i]
			nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
			nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
			min_urequests := 1 + 1*nbatch_users
			max_urequests := 2 + 2*nbatch_users
			min_vrequests := 1 * nbatch_videos
			max_vrequests := 2 * nbatch_videos

			min_total_urequests += min_urequests
			max_total_urequests += max_urequests
			min_total_vrequests += min_vrequests
			max_total_vrequests += max_vrequests

			if i == 0 {
				videos := out.Videos
				// nsubscribed_users := 55
				// nliked_videos_all := 348
				assert.Equal(t, 348, len(videos))
				assert.EqualValues(t, 1105, videos[0].VideoId)
				assert.Equal(t, "Electa Kris", videos[1].Author)
				assert.EqualValues(t, 1264, videos[2].VideoId)
				assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
				assert.Equal(t, "Tealplant: back up", videos[4].Title)
			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		assert.True(t, vrService.TotalUserRequests >= uint64(min_total_urequests) && vrService.TotalUserRequests <= uint64(max_total_urequests))
		assert.True(t, vrService.TotalVideoRequests >= uint64(min_total_vrequests) && vrService.TotalVideoRequests <= uint64(max_total_vrequests))
		// assert.True(t, vrService.TotalUserRequests >= uint64(min_total_urequests) && vrService.TotalUserRequests <= uint64(max_total_urequests), fmt.Sprintf("total user requests should between %v and %v, in fact got: %v ", min_total_urequests, max_total_urequests, vrService.TotalUserRequests))
		// assert.True(t, vrService.TotalVideoRequests >= uint64(min_total_vrequests) && vrService.TotalVideoRequests <= uint64(max_total_vrequests), fmt.Sprintf("total video requests should between %v and %v, in fact got: %v ", min_total_vrequests, max_total_vrequests, vrService.TotalVideoRequests))

		// fmt.Printf("total user requests should between %v and %v, in fact got: %v ", min_total_urequests, max_total_urequests, vrService.TotalUserRequests)
		// fmt.Printf("total video requests should between %v and %v, in fact got: %v ", min_total_vrequests, max_total_vrequests, vrService.TotalVideoRequests)

		// assert.Equal(t, 348, len(videos))
		// assert.EqualValues(t, 1105, videos[0].VideoId)
		// assert.Equal(t, "Electa Kris", videos[1].Author)
		// assert.EqualValues(t, 1264, videos[2].VideoId)
		// assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
		// assert.Equal(t, "Tealplant: back up", videos[4].Title)

		// TotalRequests may consist of:
		// GetUser(): 1~2 requests
		// get_liked_videos(): ((1~2) * nbatch_users) requests where nbatch_users := int(math.Ceil(float64(len(subscribed_to))/float64(server.options.MaxBatchSize)))
		// get_video_infos(): ((1~2) * nbatch_videos) requests where nbatch_videos := int(math.Ceil(float64(len(liked_videos_all))/float64(server.options.MaxBatchSize)))

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.False(t, err == nil)
	})
}

func TestStats(t *testing.T) {
	t.Run("test TotalRequests", func(t *testing.T) {
		max_batchsize := 50
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		// var userId uint64 = 204054
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		// var userId uint64 = 203553
		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		// num_unique_liked_videos := []int{
		// 	348,332,279,353,332,120,328,353,240,327,255,293,319,237,329,360,155,355,227,199,216,124,337,280,196,291,332,299,265,335,331,324,176,358,354,221,314,308,318,148,360,370,259,352,322,340,306,327,345,322,340,348,324,267,316,213,
		// }
		// num_subscribedto_users := []int{
		// 	55,55,31,57,46,10,46,54,21,43,29,44,38,23,55,59,13,56,24,21,22,10,45,30,18,39,51,38,27,47,43,53,16,54,57,23,38,38,48,12,59,57,31,58,41,57,33,47,50,41,51,55,48,30,42,19,
		// }
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		done := make(chan struct{})

		for i := 0; i < len(userIds); i++ {
			go func(i int) {
				out, err := vrService.GetTopVideos(
					ctx,
					&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
				)
				assert.True(t, err == nil)

				if i == 0 {
					videos := out.Videos
					// nsubscribed_users := 55
					// nliked_videos_all := 348
					assert.Equal(t, 348, len(videos))
					assert.EqualValues(t, 1105, videos[0].VideoId)
					assert.Equal(t, "Electa Kris", videos[1].Author)
					assert.EqualValues(t, 1264, videos[2].VideoId)
					assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
					assert.Equal(t, "Tealplant: back up", videos[4].Title)
				}
				done <- struct{}{}
			}(i)
		}
		for i := 0; i < len(userIds); i++ {
			<-done
		}
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)

		// TotalRequests may consist of:
		// GetUser(): 1~2 requests
		// get_liked_videos(): ((1~2) * nbatch_users) requests where nbatch_users := int(math.Ceil(float64(len(subscribed_to))/float64(server.options.MaxBatchSize)))
		// get_video_infos(): ((1~2) * nbatch_videos) requests where nbatch_videos := int(math.Ceil(float64(len(liked_videos_all))/float64(server.options.MaxBatchSize)))

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("test TotalErrors", func(t *testing.T) {
		max_batchsize := 10
		failure_rate := int64(20)
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		// var userId uint64 = 204054 203553
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})

		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			out, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			// assert.True(t, err == nil)
			if err == nil {
				nsubscribed_users := num_subscribedto_users[i]
				nliked_videos_all := num_unique_liked_videos[i]
				nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
				nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
				min_urequests := 1 + 1*nbatch_users
				max_urequests := 2 + 2*nbatch_users
				min_vrequests := 1 * nbatch_videos
				max_vrequests := 2 * nbatch_videos

				min_total_urequests += min_urequests
				max_total_urequests += max_urequests
				min_total_vrequests += min_vrequests
				max_total_vrequests += max_vrequests

				if i == 0 {
					videos := out.Videos
					// nsubscribed_users := 55
					// nliked_videos_all := 348
					assert.Equal(t, 348, len(videos))
					assert.EqualValues(t, 1105, videos[0].VideoId)
					assert.Equal(t, "Electa Kris", videos[1].Author)
					assert.EqualValues(t, 1264, videos[2].VideoId)
					assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
					assert.Equal(t, "Tealplant: back up", videos[4].Title)
				}
			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		// since we disabled retry and fallback here, there
		min_uerrors := (int64(min_total_urequests) + failure_rate - 1) / failure_rate
		min_verrors := (int64(min_total_vrequests) + failure_rate - 1) / failure_rate

		min_errors := min_uerrors
		if min_verrors < min_uerrors {
			min_errors = min_verrors
		}
		max_errors := vrService.UserServiceErrors + vrService.VideoServiceErrors

		assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors))
		// assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors), fmt.Sprintf("TotalErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests))
		// fmt.Printf("TotalErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests)

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("test UserServiceErrors", func(t *testing.T) {
		max_batchsize := 20
		failure_rate := int64(20)
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		// var userId uint64 = 204054 203553
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})

		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			out, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			// assert.True(t, err == nil)
			if err == nil {
				nsubscribed_users := num_subscribedto_users[i]
				nliked_videos_all := num_unique_liked_videos[i]
				nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
				nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
				min_urequests := 1 + 1*nbatch_users
				max_urequests := 2 + 2*nbatch_users
				min_vrequests := 1 * nbatch_videos
				max_vrequests := 2 * nbatch_videos

				min_total_urequests += min_urequests
				max_total_urequests += max_urequests
				min_total_vrequests += min_vrequests
				max_total_vrequests += max_vrequests

				if i == 0 {
					videos := out.Videos
					// nsubscribed_users := 55
					// nliked_videos_all := 348
					assert.Equal(t, 348, len(videos))
					assert.EqualValues(t, 1105, videos[0].VideoId)
					assert.Equal(t, "Electa Kris", videos[1].Author)
					assert.EqualValues(t, 1264, videos[2].VideoId)
					assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
					assert.Equal(t, "Tealplant: back up", videos[4].Title)
				}
			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		// since we disabled retry and fallback here, there
		min_uerrors := (int64(min_total_urequests) + failure_rate - 1) / failure_rate
		// min_verrors := (int64(min_total_vrequests) + failure_rate - 1) / failure_rate

		min_errors := min_uerrors
		// if min_verrors < min_uerrors {
		// 	min_errors = min_verrors
		// }
		max_errors := vrService.TotalUserRequests

		assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors))
		// assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors), fmt.Sprintf("total UserServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests))
		// fmt.Printf("total UserServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests)

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("test VideoServiceErrors", func(t *testing.T) {
		max_batchsize := 15
		failure_rate := int64(20)
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		// var userId uint64 = 204054 203553
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})

		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			out, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			// assert.True(t, err == nil)
			if err == nil {
				nsubscribed_users := num_subscribedto_users[i]
				nliked_videos_all := num_unique_liked_videos[i]
				nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
				nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
				min_urequests := 1 + 1*nbatch_users
				max_urequests := 2 + 2*nbatch_users
				min_vrequests := 1 * nbatch_videos
				max_vrequests := 2 * nbatch_videos

				min_total_urequests += min_urequests
				max_total_urequests += max_urequests
				min_total_vrequests += min_vrequests
				max_total_vrequests += max_vrequests

				if i == 0 {
					videos := out.Videos
					// nsubscribed_users := 55
					// nliked_videos_all := 348
					assert.Equal(t, 348, len(videos))
					assert.EqualValues(t, 1105, videos[0].VideoId)
					assert.Equal(t, "Electa Kris", videos[1].Author)
					assert.EqualValues(t, 1264, videos[2].VideoId)
					assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
					assert.Equal(t, "Tealplant: back up", videos[4].Title)
				}
			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		// since we disabled retry and fallback here, there
		// min_uerrors := (int64(min_total_urequests) + failure_rate - 1) / failure_rate
		min_verrors := (int64(min_total_vrequests) + failure_rate - 1) / failure_rate

		min_errors := min_verrors
		// if min_verrors < min_uerrors {
		// 	min_errors = min_verrors
		// }
		max_errors := vrService.TotalVideoRequests

		assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors))
		// assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors), fmt.Sprintf("total VideoServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests))
		// fmt.Printf("total VideoServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests)

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.False(t, err == nil)
	})

	t.Run("test StaleResponses", func(t *testing.T) {
		max_batchsize := 10
		failure_rate := int64(30)
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: false,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		vrService.ContinuallyRefreshCache()

		// var userId uint64 = 204054 203553
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})

		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			out, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			// assert.True(t, err == nil)
			if err == nil {
				nsubscribed_users := num_subscribedto_users[i]
				nliked_videos_all := num_unique_liked_videos[i]
				nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
				nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
				min_urequests := 1 + 1*nbatch_users
				max_urequests := 2 + 2*nbatch_users
				min_vrequests := 1 * nbatch_videos
				max_vrequests := 2 * nbatch_videos

				min_total_urequests += min_urequests
				max_total_urequests += max_urequests
				min_total_vrequests += min_vrequests
				max_total_vrequests += max_vrequests

				if i == 0 {
					videos := out.Videos
					// nsubscribed_users := 55
					// nliked_videos_all := 348
					assert.Equal(t, 348, len(videos))
					assert.EqualValues(t, 1105, videos[0].VideoId)
					assert.Equal(t, "Electa Kris", videos[1].Author)
					assert.EqualValues(t, 1264, videos[2].VideoId)
					assert.Equal(t, "https://video-data.localhost/blob/1211", videos[3].Url)
					assert.Equal(t, "Tealplant: back up", videos[4].Title)
				}
			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		// since we disabled retry and fallback here, there
		// min_uerrors := (int64(min_total_urequests) + failure_rate - 1) / failure_rate
		// min_verrors := (int64(len(min_total_vrequests)) + failure_rate - 1) / failure_rate

		min_errors := (int64(len(userIds)) + failure_rate - 1) / failure_rate
		// if min_verrors < min_uerrors {
		// 	min_errors = min_verrors
		// }
		max_errors := vrService.TotalRequests // equivalent to len(userIds)

		assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors))
		assert.True(t, int64(vrService.StaleResponses) >= int64(min_errors-5) && int64(vrService.StaleResponses) <= int64(max_errors))
		// assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors), fmt.Sprintf("total VideoServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests))
		// assert.True(t, int64(vrService.StaleResponses) >= int64(min_errors-5) && int64(vrService.StaleResponses) <= int64(max_errors), fmt.Sprintf("StaleResponses should between %v and %v, in fact got: %v, total user requests: %v", min_errors-5, max_errors, vrService.StaleResponses, vrService.TotalUserRequests))

		// fmt.Printf("StaleResponses should between %v and %v, in fact got: %v, total user requests: %v", min_errors-5, max_errors, vrService.StaleResponses, vrService.TotalUserRequests)

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and enabled fallback, we expect the VideoRecService to not
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.True(t, err == nil)
	})
}

func TestErrorHandling(t *testing.T) {
	max_batchsize := 25
	vrOptions := sl.VideoRecServiceOptions{
		MaxBatchSize:    max_batchsize,
		DisableFallback: true,
		DisableRetry:    true,
	}
	uClient :=
		umc.MakeMockUserServiceClient(usl.UserServiceOptions{
			Seed:                 42,
			SleepNs:              0,
			FailureRate:          0,
			ResponseOmissionRate: 0,
			MaxBatchSize:         max_batchsize,
		})
	vClient :=
		vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
			Seed:                 42,
			TtlSeconds:           60,
			SleepNs:              0,
			FailureRate:          0,
			ResponseOmissionRate: 0,
			MaxBatchSize:         max_batchsize,
		})
	vrService := sl.MakeVideoRecServiceServerWithMocks(
		vrOptions,
		uClient,
		vClient,
	)
	t.Run("test with SleepNs", func(t *testing.T) {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				SleepNs: 15 * 1e9, // sleep for 15 seconds
			},
		})

		var userId uint64 = 203553
		_, err := vrService.GetTopVideos(ctx, &pb.GetTopVideosRequest{UserId: userId, Limit: 5})
		assert.False(t, err == nil)

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and fallback, we expect the VideoRecService to
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err = vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
		)
		assert.False(t, err == nil)
	})

	// t.Run("test with response omission", func(t *testing.T) {
	// 	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	// 	defer cancel()
	// 	vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
	// 		Config: &fipb.InjectionConfig{
	// 			ResponseOmissionRate: 10,
	// 		},
	// 	})

	// 	var userId uint64 = 203553
	// 	vrService.ContinuallyRefreshCache()
	// 	_, err := vrService.GetTopVideos(ctx, &pb.GetTopVideosRequest{UserId: userId, Limit: 5})
	// 	assert.True(t, err != nil)

	// 	ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
	// 	defer cancel()
	// 	vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
	// 		Config: &fipb.InjectionConfig{
	// 			// fail one in 1 request, i.e., always fail
	// 			FailureRate: 1,
	// 		},
	// 	})

	// 	// Since we disabled retry and fallback, we expect the VideoRecService to
	// 	// throw an error since the VideoService is "down".
	// 	ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
	// 	defer cancel()
	// 	_, err = vrService.GetTopVideos(
	// 		ctx,
	// 		&pb.GetTopVideosRequest{UserId: userId, Limit: 5},
	// 	)
	// 	assert.False(t, err == nil)

	// })

}

func TestRetrying(t *testing.T) {
	t.Run("test with retry enabled", func(t *testing.T) {
		failure_rate := int64(5)
		max_batchsize := 25
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: true,
			DisableRetry:    false,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		vrService.ContinuallyRefreshCache()

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				FailureRate: 5,
			},
		})

		var userId uint64 = 203553
		out, err := vrService.GetTopVideos(ctx, &pb.GetTopVideosRequest{UserId: userId, Limit: 5})

		// nsubscribed_users := 55
		nliked_videos_all := 348
		// nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
		nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
		// min_urequests := 1 + 1*nbatch_users
		// max_urequests := 2 + 2*nbatch_users
		min_vrequests := 1 * nbatch_videos
		max_vrequests := 2 * nbatch_videos

		min_verrors := (int64(min_vrequests) + failure_rate - 1) / failure_rate

		// min_errors := min_verrors
		// if min_verrors < min_uerrors {
		// 	min_errors = min_verrors
		// }
		max_errors := min_verrors + failure_rate

		assert.True(t, int64(vrService.VideoServiceErrors) >= 0 && int64(vrService.VideoServiceErrors) <= int64(max_errors))
		assert.True(t, int64(vrService.TotalVideoRequests) > (int64(min_vrequests)-failure_rate) && int64(vrService.TotalVideoRequests) <= int64(max_vrequests))
		// assert.True(t, int64(vrService.VideoServiceErrors) >= 0 && int64(vrService.VideoServiceErrors) <= int64(max_errors), fmt.Sprintf("total VideoServiceErrors should between 0 and %v, in fact got: %v, total video requests: %v ", max_errors, vrService.VideoServiceErrors, vrService.TotalVideoRequests))
		// assert.True(t, int64(vrService.TotalVideoRequests) > (int64(min_vrequests)-failure_rate) && int64(vrService.TotalVideoRequests) <= int64(max_vrequests), fmt.Sprintf("TotalVideoRequests should between %v and %v, in fact got: %v, total video requests: %v ", (int64(min_vrequests)-failure_rate), max_vrequests, vrService.TotalVideoRequests, vrService.TotalUserRequests))

		// fmt.Printf("total VideoServiceErrors should between 0 and %v, in fact got: %v, TotalVideoRequests: %v ", max_errors, vrService.VideoServiceErrors, vrService.TotalVideoRequests)

		if err == nil {
			videos := out.Videos
			assert.True(t, len(videos) <= nliked_videos_all)
		}

	})
}

func TestFallback(t *testing.T) {
	t.Run("test with fallback enabled", func(t *testing.T) {
		max_batchsize := 15
		failure_rate := int64(30)
		vrOptions := sl.VideoRecServiceOptions{
			MaxBatchSize:    max_batchsize,
			DisableFallback: false,
			DisableRetry:    true,
		}
		uClient :=
			umc.MakeMockUserServiceClient(usl.UserServiceOptions{
				Seed:                 42,
				SleepNs:              0,
				FailureRate:          0,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vClient :=
			vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
				Seed:                 42,
				TtlSeconds:           60,
				SleepNs:              0,
				FailureRate:          failure_rate,
				ResponseOmissionRate: 0,
				MaxBatchSize:         max_batchsize,
			})
		vrService := sl.MakeVideoRecServiceServerWithMocks(
			vrOptions,
			uClient,
			vClient,
		)

		vrService.ContinuallyRefreshCache()

		// var userId uint64 = 204054 203553
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		userIds := []uint64{
			203553, 209124, 200387, 209038, 207728, 205634, 205191, 204660, 209743, 205301, 201830, 209070, 209401, 209774, 207514, 207985, 203529, 207243, 201108, 200630, 209932, 205870, 202201, 202571, 202105, 202042, 204783, 206007, 204833, 205279, 206780, 202124, 201848, 207850, 204057, 202020, 205367, 205571, 200441, 202866, 202835, 205260, 201396, 208897, 200235, 206881, 205481, 206534, 204529, 200235, 201906, 201038, 200650, 201930, 209523, 209164,
		}
		num_unique_liked_videos := []int{
			348, 332, 279, 353, 332, 120, 328, 353, 240, 327, 255, 293, 319, 237, 329, 360, 155, 355, 227, 199, 216, 124, 337, 280, 196, 291, 332, 299, 265, 335, 331, 324, 176, 358, 354, 221, 314, 308, 318, 148, 360, 370, 259, 352, 322, 340, 306, 327, 345, 322, 340, 348, 324, 267, 316, 213,
		}
		num_subscribedto_users := []int{
			55, 55, 31, 57, 46, 10, 46, 54, 21, 43, 29, 44, 38, 23, 55, 59, 13, 56, 24, 21, 22, 10, 45, 30, 18, 39, 51, 38, 27, 47, 43, 53, 16, 54, 57, 23, 38, 38, 48, 12, 59, 57, 31, 58, 41, 57, 33, 47, 50, 41, 51, 55, 48, 30, 42, 19,
		}
		// for userId 203553: user num of users subscribed-to: 55, num of all unique liked videos: 348
		// for userId 209124: user num of users subscribed-to: 55, num of all unique liked videos: 332
		// compare with data generated by makeRandomUser()
		// done := make(chan struct{})

		min_total_urequests := 0
		max_total_urequests := 0
		min_total_vrequests := 0
		max_total_vrequests := 0

		for i := 0; i < len(userIds); i++ {
			// go func(i int) {
			_, err := vrService.GetTopVideos(
				ctx,
				&pb.GetTopVideosRequest{UserId: userIds[i], Limit: 0},
			)
			// assert.True(t, err == nil)
			if err == nil {
				nsubscribed_users := num_subscribedto_users[i]
				nliked_videos_all := num_unique_liked_videos[i]
				nbatch_users := (nsubscribed_users + max_batchsize - 1) / max_batchsize
				nbatch_videos := (nliked_videos_all + max_batchsize - 1) / max_batchsize
				min_urequests := 1 + 1*nbatch_users
				max_urequests := 2 + 2*nbatch_users
				min_vrequests := 1 * nbatch_videos
				max_vrequests := 2 * nbatch_videos

				min_total_urequests += min_urequests
				max_total_urequests += max_urequests
				min_total_vrequests += min_vrequests
				max_total_vrequests += max_vrequests

			}
			// 	done <- struct{}{}
			// } (i)
		}
		// for i := 0; i < len(userIds); i++ {
		// 	<- done
		// }
		assert.EqualValues(t, len(userIds), vrService.TotalRequests)
		// since we disabled retry and fallback here, there
		// min_uerrors := (int64(min_total_urequests) + failure_rate - 1) / failure_rate
		// min_verrors := (int64(len(min_total_vrequests)) + failure_rate - 1) / failure_rate

		min_errors := (int64(len(userIds)) + failure_rate - 1) / failure_rate
		// if min_verrors < min_uerrors {
		// 	min_errors = min_verrors
		// }
		max_errors := vrService.TotalRequests // equivalent to len(userIds)

		assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors))
		assert.True(t, int64(vrService.StaleResponses) >= int64(min_errors-5) && int64(vrService.StaleResponses) <= int64(max_errors))
		// assert.True(t, int64(vrService.TotalErrors) >= int64(min_errors-5) && int64(vrService.TotalErrors) <= int64(max_errors), fmt.Sprintf("total VideoServiceErrors should between %v and %v, in fact got: %v, total user requests: %v ", min_errors-5, max_errors, vrService.TotalErrors, vrService.TotalUserRequests))
		// assert.True(t, int64(vrService.StaleResponses) >= int64(min_errors-5) && int64(vrService.StaleResponses) <= int64(max_errors), fmt.Sprintf("StaleResponses should between %v and %v, in fact got: %v, total user requests: %v", min_errors-5, max_errors, vrService.StaleResponses, vrService.TotalUserRequests))

		// fmt.Printf("StaleResponses should between %v and %v, in fact got: %v, total user requests: %v", min_errors-5, max_errors, vrService.StaleResponses, vrService.TotalUserRequests)

		// the following data are the output printed by the mock client functions, they serve as the reference answers

		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
			Config: &fipb.InjectionConfig{
				// fail one in 1 request, i.e., always fail
				FailureRate: 1,
			},
		})

		// Since we disabled retry and enabled fallback, we expect the VideoRecService to not
		// throw an error since the VideoService is "down".
		ctx, cancel = context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		_, err := vrService.GetTopVideos(
			ctx,
			&pb.GetTopVideosRequest{UserId: userIds[0], Limit: 5},
		)
		assert.True(t, err == nil)

		// max_batchsize := 25
		// vrOptions := sl.VideoRecServiceOptions{
		// 	MaxBatchSize:    max_batchsize,
		// 	DisableFallback: false,
		// 	DisableRetry:    true,
		// }
		// uClient :=
		// 	umc.MakeMockUserServiceClient(usl.UserServiceOptions{
		// 		Seed:                 42,
		// 		SleepNs:              0,
		// 		FailureRate:          0,
		// 		ResponseOmissionRate: 0,
		// 		MaxBatchSize:         max_batchsize,
		// 	})
		// vClient :=
		// 	vmc.MakeMockVideoServiceClient(vsl.VideoServiceOptions{
		// 		Seed:                 42,
		// 		TtlSeconds:           60,
		// 		SleepNs:              0,
		// 		FailureRate:          10,
		// 		ResponseOmissionRate: 0,
		// 		MaxBatchSize:         max_batchsize,
		// 	})
		// vrService := sl.MakeVideoRecServiceServerWithMocks(
		// 	vrOptions,
		// 	uClient,
		// 	vClient,
		// )
		// vrService.ContinuallyRefreshCache()
		// // ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		// // defer cancel()

		// ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		// defer cancel()
		// // vrService.ContinuallyRefreshCache()
		// // vClient.SetInjectionConfig(ctx, &fipb.SetInjectionConfigRequest{
		// // 	Config: &fipb.InjectionConfig{
		// // 		FailureRate: 5,
		// // 	},
		// // })

		// var userId uint64 = 203553
		// _, err := vrService.GetTopVideos(ctx, &pb.GetTopVideosRequest{UserId: userId, Limit: 5})
		// assert.True(t, len(vrService.TrendingVideos) > 0)
		// assert.True(t, err==nil)
		// if err == nil {

		// }

	})
}
