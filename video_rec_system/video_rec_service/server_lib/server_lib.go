package server_lib

import (
	"context"
	upb "cs426.yale.edu/lab1/user_service/proto"
	umc "cs426.yale.edu/lab1/user_service/mock_client"
	pb "cs426.yale.edu/lab1/video_rec_service/proto"
	vmc "cs426.yale.edu/lab1/video_service/mock_client"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	ranker "cs426.yale.edu/lab1/ranker"
	"google.golang.org/grpc/credentials/insecure"
	vpb "cs426.yale.edu/lab1/video_service/proto"
	"sort"
	"log"
	"math"
	"sync"
	"time"
	tdigest "github.com/caio/go-tdigest"
	// "sync/atomic"
)

type VideoRecServiceOptions struct {
	// Server address for the UserService"
	UserServiceAddr string
	// Server address for the VideoService
	VideoServiceAddr string
	// Maximum size of batches sent to UserService and VideoService
	MaxBatchSize int
	// If set, disable fallback to cache
	DisableFallback bool
	// If set, disable all retries
	DisableRetry bool
	ClientPoolSize int
}



type VideoRecServiceServer struct {
	pb.UnimplementedVideoRecServiceServer
	options VideoRecServiceOptions
	// Add any data you want here
	u_mockclient *umc.MockUserServiceClient
	v_mockclient *vmc.MockVideoServiceClient
	TotalRequests      uint64  
	TotalErrors        uint64  
	ActiveRequests     uint64  
	UserServiceErrors  uint64  
	VideoServiceErrors uint64  
	AverageLatencyMs   float32 
	P99LatencyMs       float32 
	StaleResponses     uint64
	mu sync.Mutex
	AccumulatedLatencyMs   float32
	LatencySlice       []float32
	TrendingVideos     []*vpb.VideoInfo
	ExpirationTimeS	   uint64
	TotalUserRequests  uint64
	TotalVideoRequests uint64
	stopChan 		   chan struct{}
	// uClientConn        *grpc.ClientConn
	// vClientConn    	   *grpc.ClientConn
	nonmock_uclients   []upb.UserServiceClient
	nonmock_vclients   []vpb.VideoServiceClient
	v_ind 			   int64 
	u_ind              int64
}


func (server *VideoRecServiceServer) StopCacheRefresh() {
    close(server.stopChan) // Signal the goroutine to stop
}

// func (server *VideoRecServiceServer) GetClientPoolSize() int {
//     return server. // Signal the goroutine to stop
// }

func (server *VideoRecServiceServer) ContinuallyRefreshCache(){
	// concurrently update trending videos?
	err_chan := make(chan error)
	var err error
	// var wg sync.WaitGroup
	// wg.Add(1)
	go func() {
		// defer wg.Done()
		for {
			select {
			case <-err_chan:
				return 
			default:
				time_now := time.Now().Unix()
				// log.Printf("expire_time: %v, now: %v , len(TrendingVideos): %v", server.ExpirationTimeS, time_now, len(server.TrendingVideos))
				if time_now >= int64(server.ExpirationTimeS) {
					err = update_trending_videos(
						server,
						// ctx,
						// req,
						// mock_vclient,
						// &nonmock_vclient,
						// batchsize,
					)
					if err != nil {
						err_chan <- err
						return
					}
				}
			}
			
		}
	}()
	// wg,Wait()
}

func (server *VideoRecServiceServer) GetUserClientRoundRobin() upb.UserServiceClient {
	server.mu.Lock()
	ind := server.u_ind % int64(server.options.ClientPoolSize)
	server.u_ind++
	server.mu.Unlock()
	return server.nonmock_uclients[ind]
}

func (server *VideoRecServiceServer) GetVideoClientRoundRobin() vpb.VideoServiceClient {
	server.mu.Lock()
	ind := server.v_ind % int64(server.options.ClientPoolSize)
	server.v_ind++
	server.mu.Unlock()
	return server.nonmock_vclients[ind]
}


func MakeVideoRecServiceServer(options VideoRecServiceOptions) (*VideoRecServiceServer, error) {
	// var uerr, verr error 
	var opts []grpc.DialOption
	opts = append(opts, grpc.WithTransportCredentials(insecure.NewCredentials()))
	opts = append(opts, grpc.WithDisableServiceConfig()) // Disable gRPC service-level load balancing configuration.

	var uclient_conn, vclient_conn *grpc.ClientConn
	var uerr, verr error
	var nonmock_uclients []upb.UserServiceClient
	var nonmock_vclients []vpb.VideoServiceClient
	var nonmock_uclient upb.UserServiceClient
	var nonmock_vclient vpb.VideoServiceClient

	for i := 0; i < options.ClientPoolSize; i++ {
		uclient_conn, uerr = grpc.NewClient(options.UserServiceAddr, opts...)
		vclient_conn, verr = grpc.NewClient(options.VideoServiceAddr, opts...)

		if uerr != nil {
			return nil, uerr 
		} else if verr != nil {
			return nil, verr 
		} else {
			nonmock_uclient = upb.NewUserServiceClient(uclient_conn)
			nonmock_vclient = vpb.NewVideoServiceClient(vclient_conn)
			nonmock_uclients = append(nonmock_uclients, nonmock_uclient)
			nonmock_vclients = append(nonmock_vclients, nonmock_vclient)
		}
	}
	return &VideoRecServiceServer{
		options: options,
		// Add any data to initialize here
		u_mockclient: nil,
		v_mockclient: nil,
		LatencySlice: []float32{},
		TrendingVideos: []*vpb.VideoInfo{},
		stopChan: make(chan struct{}),
		// uClientConn: uclient_conn,
		// vClientConn: vclient_conn, 
		nonmock_uclients: nonmock_uclients,
		nonmock_vclients: nonmock_vclients,
	}, nil
	
}

func MakeVideoRecServiceServerWithMocks(
	options VideoRecServiceOptions,
	mockUserServiceClient *umc.MockUserServiceClient,
	mockVideoServiceClient *vmc.MockVideoServiceClient,
) *VideoRecServiceServer {
	// Implement your own logic here
	return &VideoRecServiceServer{
		options: options,
		// ...
		u_mockclient: mockUserServiceClient,
		v_mockclient: mockVideoServiceClient,

	}
} 
 
func update_trending_videos(
	server *VideoRecServiceServer,
	// ctx context.Context,
	// req *pb.GetTopVideosRequest,
	// video_info_fetched *[]*vpb.VideoInfo,
	// mock_vclient *vmc.MockVideoServiceClient,
	// nonmock_vclient_pt *vpb.VideoServiceClient,
	// batchsize int,
) error {
	// the context setup referenced implementation in server.test.go
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var mock_vclient *vmc.MockVideoServiceClient
	var nonmock_vclient vpb.VideoServiceClient 
	// var opts []grpc.DialOption
	// opts = append(opts, grpc.WithTransportCredentials(insecure.NewCredentials()))
	batchsize := server.options.MaxBatchSize
	var err error 

	if server.v_mockclient == nil {
		// conn2, err := grpc.NewClient(server.options.VideoServiceAddr, opts...)
		// if err != nil {
		// 	conn2, err = grpc.NewClient(server.options.VideoServiceAddr, opts...)
		
		// 	if err != nil {
		// 		err_ret := status.Errorf(status.Code(err), "Error connecting to VideoService (grpc.NewClient()): %v", err)
		// 		log.Printf("Error connecting to VideoService: %v", err)
		// 		// server.mu.Lock() 
		// 		// server.VideoServiceErrors++
		// 		// server.mu.Unlock()
		// 		return err_ret
		// 	}
		// }
		// conn2 := server.vClientConn
		// defer conn2.Close()
		// nonmock_vclient = vpb.NewVideoServiceClient(conn2)
		// nonmock_vclient = server.nonmock_vclient
		nonmock_vclient = server.GetVideoClientRoundRobin()
	} else {
		mock_vclient = server.v_mockclient
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	in_getvideo_1 := &vpb.GetTrendingVideosRequest{}
	// nonmock_vclient := *nonmock_vclient_pt
	var get_video_response1 *vpb.GetTrendingVideosResponse 

	if server.v_mockclient == nil {
		get_video_response1, err = nonmock_vclient.GetTrendingVideos(ctx, in_getvideo_1)
	} else {
		get_video_response1, err = mock_vclient.GetTrendingVideos(ctx, in_getvideo_1)
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	if err != nil {
		// retry once after 11s
		time.Sleep(11 * time.Second)
		if server.v_mockclient == nil {
			get_video_response1, err = nonmock_vclient.GetTrendingVideos(ctx, in_getvideo_1)
		} else {
			get_video_response1, err = mock_vclient.GetTrendingVideos(ctx, in_getvideo_1)
		}
		if err != nil {
			err_ret := status.Errorf(status.Code(err), "Error when running GetTrendingVideos(). total requests: %v, error: %v ", server.TotalRequests, err)
			log.Printf("Error when running GetTrendingVideos(). total requests: %v, error: %v ", server.TotalRequests, err)
			// server.mu.Lock()
			// server.VideoServiceErrors++
			// server.mu.Unlock()
			return err_ret
		}
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	video_ids := get_video_response1.GetVideos() // []uint64
	video_info_fetched := []*vpb.VideoInfo{}
	err = get_video_infos(
		server,
		ctx,
		// req,
		&video_ids, // pointer to liked_videos_all before refactor
		&video_info_fetched,
		mock_vclient,
		&nonmock_vclient,
		batchsize,
		false,
	)

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}
	if err != nil {
		// retry once after 11s
		time.Sleep(11 * time.Second)
		err = get_video_infos(
			server,
			ctx,
			// req,
			&video_ids, // pointer to liked_videos_all before refactor
			&video_info_fetched,
			mock_vclient,
			&nonmock_vclient,
			batchsize,
			false,
		)
		if err != nil {
			err_ret := status.Errorf(status.Code(err), "Error when running get_video_infos(). total requests: %v, error: %v ", server.TotalRequests, err)
			log.Printf("Error when running get_video_infos(). total requests: %v, error: %v ", server.TotalRequests, err)
			// server.mu.Lock()
			// server.VideoServiceErrors++
			// server.mu.Unlock()
			return err_ret
		}
	}
	server.mu.Lock()
	server.TrendingVideos = video_info_fetched
	server.ExpirationTimeS = get_video_response1.GetExpirationTimeS()
	server.mu.Unlock()
	return nil
}

// make a call to the UserService to find LikedVideos of the subscribed-to users
func get_liked_videos(
	server *VideoRecServiceServer,
	ctx context.Context,
	req *pb.GetTopVideosRequest,
	user_ids *[]uint64,
	liked_videos *[]uint64,
	mock_uclient *umc.MockUserServiceClient,
	nonmock_uclient_pt *upb.UserServiceClient,
	batchsize int,
) error {
	// if len(substribed_to) > MaxBatchSize 
	// liked_videos_all := []uint64{}
	subscribed_to := *user_ids 
	liked_videos_all := *liked_videos
	nonmock_uclient := *nonmock_uclient_pt
	var err error
	// log.Printf("MaxBatchSize: %v", server.options.MaxBatchSize)

	nbatch := int(math.Ceil(float64(len(subscribed_to))/float64(server.options.MaxBatchSize)))
	unique_videoid_map := make(map[uint64]bool)

	for i := 0; i < nbatch; i++ {
		var batch_users []uint64
		if i < nbatch - 1 {
			batch_users = subscribed_to[i * batchsize: (i+1) * batchsize]
		} else {
			batch_users = subscribed_to[i * batchsize:]
		}
		in2 := &upb.GetUserRequest{
			UserIds: batch_users,
		}

		var getuser_response2 *upb.GetUserResponse 
		// var err error 
		if err := ctx.Err(); err != nil {
			// Context has been cancelled or timed out, return early
			return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
		}

		if server.u_mockclient == nil {
			getuser_response2, err = nonmock_uclient.GetUser(ctx, in2)
		} else {
			getuser_response2, err = mock_uclient.GetUser(ctx, in2)
		}
		server.mu.Lock()
		server.TotalUserRequests++
		server.mu.Unlock()
		if err != nil {
			server.mu.Lock()
			server.UserServiceErrors++
			server.mu.Unlock()
			if !server.options.DisableRetry {
				if server.u_mockclient == nil {
					getuser_response2, err = nonmock_uclient.GetUser(ctx, in2)
				} else {
					getuser_response2, err = mock_uclient.GetUser(ctx, in2)
				}
			}
			server.mu.Lock()
			server.TotalUserRequests++
			server.mu.Unlock()
			if err != nil {
				log.Printf("Error when running GetUser() for users in subscribed_to: err: %v ", err)
				err_ret := status.Errorf(status.Code(err), "Error when running GetUser() for users in subscribed_to: err: %v len(substribed_to): %v", err, len(subscribed_to))
				server.mu.Lock()
				server.UserServiceErrors++
				server.mu.Unlock()
				return err_ret
			}
		}

		if err := ctx.Err(); err != nil {
			// Context has been cancelled or timed out, return early
			return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
		}

		user_infos2 := getuser_response2.GetUsers() // []*UserInfo
		
		for _, user_info := range user_infos2 {
			for _, video := range user_info.GetLikedVideos() { // video is uint64
				// check if video is already in liked_videos_all
				_, exists := unique_videoid_map[video]
				if !exists {
					liked_videos_all = append(liked_videos_all, video)
					unique_videoid_map[video] = true 
				}
			}
		}
	}
	*liked_videos = liked_videos_all
	return nil
}

func get_video_infos(
	server *VideoRecServiceServer,
	ctx context.Context,
	// req *pb.GetTopVideosRequest,
	video_ids *[]uint64, // pointer to liked_videos_all before refactor
	video_info_fetched *[]*vpb.VideoInfo,
	mock_vclient *vmc.MockVideoServiceClient,
	nonmock_vclient_pt *vpb.VideoServiceClient,
	batchsize int,
	call_from_gettopvideo bool,
) error {
	liked_videos_all := *video_ids
	nbatch_videos := int(math.Ceil(float64(len(liked_videos_all))/float64(server.options.MaxBatchSize)))
	video_infos := *video_info_fetched // []*vpb.VideoInfo{}
	nonmock_vclient := *nonmock_vclient_pt
	var batch_video_infos []*vpb.VideoInfo
	var err error
	// log.Printf("len(liked_videos_all): %v, nbatch_videos: %v ", len(liked_videos_all), nbatch_videos)

	for i := 0; i < nbatch_videos; i++ {
		var batch_videos []uint64 
		if i < nbatch_videos - 1 {
			batch_videos = liked_videos_all[i * batchsize: (i+1) * batchsize]
		} else {
			batch_videos = liked_videos_all[i * batchsize:]
		}

		in_getvideo_1 := &vpb.GetVideoRequest{
			VideoIds: batch_videos,
		}

		var get_video_response1 *vpb.GetVideoResponse

		if err := ctx.Err(); err != nil {
			// Context has been cancelled or timed out, return early
			return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
		}

		if server.v_mockclient == nil {
			get_video_response1, err = nonmock_vclient.GetVideo(ctx, in_getvideo_1)
		} else {
			get_video_response1, err = mock_vclient.GetVideo(ctx, in_getvideo_1)
		}
		server.mu.Lock()
		server.TotalVideoRequests++
		server.mu.Unlock()

		if err := ctx.Err(); err != nil {
			// Context has been cancelled or timed out, return early
			return status.Errorf(codes.Canceled, "Request cancelled: %v", err)
		}

		if err != nil {
			if call_from_gettopvideo {
				server.mu.Lock()
				server.VideoServiceErrors++
				server.mu.Unlock()
			}
			if !server.options.DisableRetry {
				if server.v_mockclient == nil {
					get_video_response1, err = nonmock_vclient.GetVideo(ctx, in_getvideo_1)
				} else {
					get_video_response1, err = mock_vclient.GetVideo(ctx, in_getvideo_1)
				}
			}
			server.mu.Lock()
			server.TotalVideoRequests++
			server.mu.Unlock()
			if err != nil {
				err_ret := status.Errorf(status.Code(err), "Error when running GetVideo() for videos in liked_videos_all. len(liked_videos_all): %v, call_from_gettopvideo = %v, nbatch_videos: %v, error: %v ", len(liked_videos_all), call_from_gettopvideo, nbatch_videos, err)
				log.Printf("Error when running GetVideo() for videos in liked_videos_all. len(liked_videos_all): %v, call_from_gettopvideo = %v, nbatch_videos: %v, error: %v ", len(liked_videos_all), call_from_gettopvideo, nbatch_videos, err)
				if call_from_gettopvideo {
					server.mu.Lock()
					server.VideoServiceErrors++
					server.mu.Unlock()
				}
				return err_ret
			}
		}
		batch_video_infos = get_video_response1.GetVideos() // []*VideoInfo
		for _, vinfo := range batch_video_infos {
			video_infos = append(video_infos, vinfo)
		}

	}
	*video_info_fetched = video_infos
	return nil
}

func rank_and_truncate (
	video_info_fetched *[]*vpb.VideoInfo,
	req_user_coeffs *upb.UserCoefficients,
	limit int32,
	trunc_vlst *[]*vpb.VideoInfo,
) {
	rank_ret := []map[string]uint64{}
	br := &ranker.BcryptRanker{}
	var single_video_rank uint64
	video_infos := *video_info_fetched

	for i, video_info := range video_infos {
		if video_info.GetVideoCoefficients() == nil {
			continue
		}
		single_video_rank = br.Rank(req_user_coeffs, video_info.GetVideoCoefficients())
		rank_ret = append(rank_ret, map[string]uint64{"ind": uint64(i), "rank_score": single_video_rank})
	}
	
	// sort/rank
	sort.Slice(rank_ret, func(i, j int) bool {
		return rank_ret[i]["rank_score"] > rank_ret[j]["rank_score"]
	})

	sorted_videoinfos := []*vpb.VideoInfo{}
	for _, rk_map := range rank_ret {
		sorted_videoinfos = append(sorted_videoinfos, video_infos[rk_map["ind"]])
	}

	// truncate the list based on limit in req
	truncated_vlst := []*vpb.VideoInfo{}
	// limit := req.GetLimit()
	if limit > 0 && limit <= int32(len(sorted_videoinfos)) {
		truncated_vlst = sorted_videoinfos[:limit]
	} else { // either limit > len(sourted_videoinfos) or limit == 0
		truncated_vlst = sorted_videoinfos
	}
	*trunc_vlst = truncated_vlst
}


func (server *VideoRecServiceServer) GetTopVideos(
	ctx context.Context,
	req *pb.GetTopVideosRequest,
) (*pb.GetTopVideosResponse, error) {
	start := time.Now()
	server.mu.Lock()
	server.TotalRequests++ 
	server.ActiveRequests++
	server.mu.Unlock()

	var err error 
	batchsize := server.options.MaxBatchSize
	// var opts []grpc.DialOption
	// opts = append(opts, grpc.WithTransportCredentials(insecure.NewCredentials()))
	// ctx, cancel := context.WithCancel(ctx)

	defer func() {
		latency := time.Since(start).Milliseconds()
		server.mu.Lock()
		server.ActiveRequests--
		server.LatencySlice = append(server.LatencySlice, float32(latency))
		server.AccumulatedLatencyMs += float32(latency)
		server.AverageLatencyMs = server.AccumulatedLatencyMs/float32(server.TotalRequests)
		server.mu.Unlock()
		// cancel() // cancel the context to stop the go routine
	} ()

	// create video client
	var mock_vclient *vmc.MockVideoServiceClient
	var nonmock_vclient vpb.VideoServiceClient 
	if server.v_mockclient == nil {
		// conn2, err := grpc.NewClient(server.options.VideoServiceAddr, opts...)
		// if err != nil {
		// 	server.mu.Lock()
		// 	server.VideoServiceErrors++
		// 	server.mu.Unlock()
		// 	if !server.options.DisableRetry {
		// 		conn2, err = grpc.NewClient(server.options.VideoServiceAddr, opts...)
		// 	}
		// 	if err != nil {
		// 		if !server.options.DisableFallback && len(server.TrendingVideos) > 0 {
		// 			server.mu.Lock()
		// 			server.StaleResponses++
		// 			server.mu.Unlock()
		// 			ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
		// 				Videos: server.TrendingVideos,
		// 				StaleResponse: true,
		// 			}
		// 			return ret_GetTopVideosResponse, nil
		// 		} else {
		// 			err_ret := status.Errorf(status.Code(err), "Error connecting to VideoService (grpc.NewClient()): %v", err)
		// 			log.Printf("Error connecting to VideoService: %v", err)
		// 			server.mu.Lock()
		// 			server.VideoServiceErrors++
		// 			server.TotalErrors++
		// 			server.mu.Unlock()
		// 			return nil, err_ret
		// 		}
		// 		// return nil, err_ret
		// 	}
			
		// }
		// conn2 := server.vClientConn
		// defer conn2.Close()
		// nonmock_vclient = vpb.NewVideoServiceClient(conn2)
		// nonmock_vclient = server.nonmock_vclient
		nonmock_vclient = server.GetVideoClientRoundRobin()
	} else {
		mock_vclient = server.v_mockclient
	}


	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return nil, status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	// create user client
	var mock_uclient *umc.MockUserServiceClient 
	var nonmock_uclient upb.UserServiceClient 
	
	if server.u_mockclient == nil {
		// conn, err := grpc.NewClient(server.options.UserServiceAddr, opts...)
		// defer conn.Close()
	
		// if err != nil {
		// 	server.mu.Lock()
		// 	server.UserServiceErrors++
		// 	server.mu.Unlock()
		// 	// retry
		// 	if !server.options.DisableRetry {
		// 		conn, err = grpc.NewClient(server.options.UserServiceAddr, opts...)
		// 	}
		// 	if err != nil {
		// 		err_ret := status.Errorf(status.Code(err), "Error connecting to UserService (grpc.NewClient()): %v", err)
		// 		log.Printf("Error connecting to UserService: %v", err)
		// 		server.mu.Lock()
		// 		server.UserServiceErrors++
		// 		server.mu.Unlock()
		// 		if !server.options.DisableFallback && len(server.TrendingVideos) > 0 {
		// 			server.mu.Lock()
		// 			server.StaleResponses++
		// 			server.mu.Unlock()
		// 			ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
		// 				Videos: server.TrendingVideos,
		// 				StaleResponse: true,
		// 			}
		// 			return ret_GetTopVideosResponse, nil
		// 		} else {
		// 			server.mu.Lock()
		// 			server.TotalErrors++
		// 			server.mu.Unlock()
		// 			return nil, err_ret
		// 		}
		// 	}
		// }
		// A3
		// find the users that the original userh (specified by UserId on the original request) subscribes to
		// conn := server.uClientConn 
		// defer conn.Close()
		// nonmock_uclient = upb.NewUserServiceClient(conn)
		// nonmock_uclient = server.nonmock_uclient
		nonmock_uclient = server.GetUserClientRoundRobin()
	} else {
		mock_uclient = server.u_mockclient
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return nil, status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	in1 := &upb.GetUserRequest{
		UserIds: []uint64{req.GetUserId()},
	}

	var getuser_response1 *upb.GetUserResponse 

	if server.u_mockclient == nil {
		getuser_response1, err = nonmock_uclient.GetUser(ctx, in1)
		
	} else {
		getuser_response1, err = mock_uclient.GetUser(ctx, in1)
	}
	server.mu.Lock()
	server.TotalUserRequests++
	server.mu.Unlock()
	if err != nil {
		if !server.options.DisableRetry {
			if server.u_mockclient == nil {
				getuser_response1, err = nonmock_uclient.GetUser(ctx, in1)
				
			} else {
				getuser_response1, err = mock_uclient.GetUser(ctx, in1)
			}
		}
		server.mu.Lock()
		server.TotalUserRequests++
		server.mu.Unlock()
		if err != nil {
			err_ret := status.Errorf(status.Code(err), "Error when running GetUser() for UserId: %v, error: %v ",in1.UserIds,  err)
			log.Printf("Error when running GetUser() for UserId: %v, error: %v ",in1.UserIds,  err)
			server.mu.Lock()
			server.UserServiceErrors++
			server.mu.Unlock()
			if !server.options.DisableFallback && len(server.TrendingVideos) > 0 {
				server.mu.Lock()
				server.StaleResponses++
				server.mu.Unlock()
				ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
					Videos: server.TrendingVideos,
					StaleResponse: true,
				}
				return ret_GetTopVideosResponse, nil
			} else {
				server.mu.Lock()
				server.TotalErrors++
				server.mu.Unlock()
				return nil, err_ret
			}
		}
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return nil, status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	user_infos := getuser_response1.GetUsers() // []*UserInfo
	subscribed_to := []uint64{} //[]uint64
	var req_user_coeffs *upb.UserCoefficients

	for _, user_info := range user_infos {
		if user_info.GetUserId() == req.GetUserId() {
			subscribed_to = user_info.GetSubscribedTo()
			req_user_coeffs = user_info.GetUserCoefficients()
			break
		}
	}

	if len(subscribed_to) == 0 {
		if req_user_coeffs == nil {
			err_ret := status.Errorf(codes.NotFound, "User coeff not found for user with userId = %v", req.GetUserId())
			log.Printf("User coeff not found for user with userId = %v", req.GetUserId())
			if len(server.TrendingVideos) > 0 {
				ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
					Videos: server.TrendingVideos,
				}
				return ret_GetTopVideosResponse, nil
			} else {
				// server.mu.Lock()
				// server.TotalErrors++
				// server.mu.Unlock()
				return nil, err_ret
			}
		} else {
			// the user didn't subscribe to any youtubers
			// either return empty response without error, or return an error
			// err_ret := grpc.Errorf(code.NotFound, "This user didn't substribe to anyone.")
			log.Printf("This user didn't substribe to anyone.")
			if len(server.TrendingVideos) > 0 {
				ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
					Videos: server.TrendingVideos,
				}
				return ret_GetTopVideosResponse, nil
			} else {
				ret := &pb.GetTopVideosResponse{}
				// server.mu.Lock()
				// server.TotalErrors++
				// server.mu.Unlock()
				return ret, nil
			}
		}
	}

	// make another call to the UserService to find LikedVideos of the subscribed-to users
	liked_videos_all := []uint64{}
	err = get_liked_videos(
		server,
		ctx,
		req,
		&subscribed_to,
		&liked_videos_all,
		mock_uclient,
		&nonmock_uclient,
		batchsize,
	)
	if err != nil {
		if !server.options.DisableFallback && len(server.TrendingVideos) > 0 {
			server.mu.Lock()
			server.StaleResponses++
			server.mu.Unlock()
			ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
				Videos: server.TrendingVideos,
				StaleResponse: true,
			}
			return ret_GetTopVideosResponse, nil
		} else {
			server.mu.Lock()
			server.TotalErrors++
			server.mu.Unlock()
			return nil, err
		}
	}
	
	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return nil, status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	// get videoInfo for videos in liked_videos_all
	video_infos := []*vpb.VideoInfo{}
	
	err = get_video_infos(
		server,
		ctx,
		// req,
		&liked_videos_all,
		&video_infos,
		mock_vclient,
		&nonmock_vclient,
		batchsize,
		true,
	)
	if err != nil {
		log.Printf("DisableFallback: %v, len(): %v ", server.options.DisableFallback, len(server.TrendingVideos))
		if !server.options.DisableFallback && len(server.TrendingVideos) > 0 {
			server.mu.Lock()
			// server.TotalErrors++
			server.StaleResponses++
			server.mu.Unlock()
			ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
				Videos: server.TrendingVideos,
				StaleResponse: true,
			}
			return ret_GetTopVideosResponse, nil
		} else {
			server.mu.Lock()
			server.TotalErrors++
			server.mu.Unlock()
			return nil, err
		}
	}

	if err := ctx.Err(); err != nil {
		// Context has been cancelled or timed out, return early
		return nil, status.Errorf(codes.Canceled, "Request cancelled: %v", err)
	}

	// A5 rank & truncate the returned videos
	limit := req.GetLimit()
	truncated_vlst := []*vpb.VideoInfo{}
	rank_and_truncate (
		&video_infos,
		req_user_coeffs,
		limit,
		&truncated_vlst,
	)
	
	ret_GetTopVideosResponse := &pb.GetTopVideosResponse{
		Videos: truncated_vlst,
	}

	// log.Printf("num of users subscribed-to: %v, num of all liked videos: %v, num of *VideoInfo fetched: %v, num of final returned videos: %v", len(subscribed_to), len(liked_videos_all), len(video_infos), len(truncated_vlst))

	return ret_GetTopVideosResponse, nil
	// return nil, status.Error( 
	// 	codes.Unimplemented,
	// 	"VideoRecService: unimplemented!",
	// )
}

func (server *VideoRecServiceServer) GetStats(
	ctx context.Context,
	req *pb.GetStatsRequest,
) (*pb.GetStatsResponse, error) {
	td, err := tdigest.New() // t_digest: *TDigest
	if err != nil {
		log.Printf("Error in tdigest.New(): %v ", err)
		// server.mu.Lock()
		// server.P99LatencyMs = -1 //indicate an error condition
		// server.mu.Unlock()
		return nil, err
	} else {
		for _, latency := range server.LatencySlice {
			td.AddWeighted(float64(latency),1)
		}
		p99_latency_ms := td.Quantile(0.99)
		server.mu.Lock()
		server.P99LatencyMs = float32(p99_latency_ms)
		server.mu.Unlock()
	}
	ret := &pb.GetStatsResponse{
		TotalRequests: server.TotalRequests,
		TotalErrors: server.TotalErrors,
		ActiveRequests: server.ActiveRequests,
		UserServiceErrors: server.UserServiceErrors,
		VideoServiceErrors: server.VideoServiceErrors,
		AverageLatencyMs: server.AverageLatencyMs,
		P99LatencyMs: server.P99LatencyMs,
		StaleResponses: server.StaleResponses,
	}
	return ret, nil
}
