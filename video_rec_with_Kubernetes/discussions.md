UUID  
What are the properties of the UUID format? Many languages have standard libraries for generating UUIDs. How does its generation guaratee universal uniqueness?   
  
-UUIDs are 128-bit identifiers, in which 2 to 4 bits are used to indicate the format's variant, and the use of the remaining bits is governed by the variant/version selected. This creates a massive address space of 2^128 possible identifiers;   
-The generation of a UUID does relies on standard algorithms, not on a central registration authority or coordination between the parties generating them, unlike most other numbering schemes;  
    -UUIDs come in several versions, each with different generation methods. For example:
	    -Version 1 uses the timestamp and the machine’s MAC address, making it unique to the specific machine and time;
	    -Version 4 relies on random or pseudo-random numbers. Out of the 128 bits, only 122 bits are random, but this still provides approximately 5.3 × 10^36 possibilities.  
-While the probability that a UUID will be duplicated is not zero, it is generally considered close enough to zero to be negligible. This means that:   
    -Anyone can create a UUID and use it to identify something with near certainty that the identifier does not duplicate one that has already been, or will be, created to identify something else.  
    -Information labeled with UUIDs by independent parties can be later combined into a single database or transmitted on the same channel, with a negligible probability of duplication.  

B1  
What do you think will happen if you delete the pod running your service? Note down your prediction, then run kubectl delete pod <pod-name> (you can find the name with kubectl get pod) and wait a few seconds, then run kubectl get pod again. What happened and why do you think so?
Prediction:  
The pod deleted will be terminated and the corresponding running service will be down.  

Output:  
c7cd295c4fc4:~/cs426-workdir/cs426-fall24/lab1$ kubectl get pod
NAME                         READY   STATUS    RESTARTS         AGE
video-rec-56476c7cf5-wc4lb   1/1     Running   11 (5m56s ago)   5h53m
c7cd295c4fc4:~/cs426-workdir/cs426-fall24/lab1$ kubectl delete pod video-rec-56476c7cf5-wc4lb
pod "video-rec-56476c7cf5-wc4lb" deleted
E0928 03:01:11.275433   34753 reflector.go:150] k8s.io/client-go/tools/watch/informerwatcher.go:146: Failed to watch *unstructured.Unstructured: unknown
E0928 03:01:12.547544   34753 reflector.go:150] k8s.io/client-go/tools/watch/informerwatcher.go:146: Failed to watch *unstructured.Unstructured: unknown
c7cd295c4fc4:~/cs426-workdir/cs426-fall24/lab1$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
video-rec-56476c7cf5-2swgj   1/1     Running   0          42s

What happened: Kubernetes created a new pod and assigned the previously running service to continue on this pod.  
Kubernetes performs this kind of seamless replacement as part of its design to provide high availability, reliability and resilience for applications:  
    -Kubernetes is self-healing in that it operates on the desired state predefined. If it has been set up that there should be n replicas of a pod running at any time, kubernetes ensures that this state is maintained and automatically detects adjust the difference between the actual state and the desired state.  
    -Pods in Kubernetes are designed to be ephemeral, meaning that they can be created, destroyed, or moved between nodes at any given time. When a pod goes down due to any issue, another pod is created and scheduled on a healthy node to ensure service continuity.


B4  
Output:  
Welcome! You have chosen user ID 202463 (Shields4750/murphywilkinson@mckenzie.info)

Their recommended videos are:
 1. Moledid: reboot by Taurean Hauck
 2. The lingering lizard's fire by Nya Greenfelder
 3. The blushing marten's milk by Paige Anderson
 4. attractive below by Dora Mertz
 5. The vast donkey's furniture by Ayden McLaughlin
  

C3  
What does the load distribution look like with a client pool size of 4? What would you expect to happen if you used 1 client? How about 8?  
Looking at the charts, with a client pool size of 4, there are in total around 4 rounds of requests sent out, the total count of requests are close across each round. In each round, the requests were processed by both backing pods, and the backing pod that get more requests at a certain round got less requests at the following round, and vice versa.  
  
If we use 1 client, it would likely be several rounds of requests with number of requests equally distributed across rounds, all sent to one of the backing pods.  
  
If we use 8 clients, the pattern would likely be similar to that with client pool size of 4, with the requests being spread relatively evenly between both backing pods and across each round of request sent. Since there are more available clients, there may be higher number of requests sent at a single round than that with a client pool size of 4.     



