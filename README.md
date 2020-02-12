User deployment guide
=====================

- Deployment cycle test

```
0. Clone down this repository ()
1. Configure Azure cloud parameters in this file: ../.access.sh (use the provided access.sh template)
2. run ./deploy.sh deploy
3. Paste the url provided into a browser upon deployment to confirm if the app is ready
4. Do kubetcl get pods to list the deployed application pods 
5. Scale up: utilities/scale.sh 2
6. Scale up: utilities/scale.sh 1 
7. Run ./deploy.sh decomm
8. Check if the application is no longer available by visiting the URL again
```

Design and Implementation Process
=================================

Story
=====

- The business requirements were articulated in the following story:

```
You will need to write code to provision infrastructure on a cloud of your choice as
AWS, GCP or Azure as per the requirements specified below. You can add goodies of
your own

- Tools

You can use any of the tools including Terraform, Ansible, or Cloud specific
implementations such as CloudFormation etc. You are also welcome to use the
services provided by your chosen Cloud Provider.

- Requirements: You should devise a method to provision the following application that is:

• Automated
• Configurable
• Reproducible

Launch a WordPress application (You will easily find a suitable docker image) with high
availability that can be reached from the internet via an IP address or a DNS name.
This deployment must allow an operator to scale up or down the number of replicas of
the application without too much effort. It is not a basic requirement to implement the
logic to automatically scale the application — it will be done by a human operator.
```

Requirement Analysis
====================

[] 1. Launch a WordPress application (You will easily find a suitable docker image) 
  
  [] 1.1 Therefore containerised W.P providing 
    [] 1.1.1 application and 
    [] 1.1.2 DB will be required
  [] 2. with high availability (therefore, ideally, an orchestration platform/tool will be needed - e.g K8s)
   [] 2.1 that can be reached from the internet (therefore load-balancing or reverse-proxy will be needed) 
    [] 2.1.1 via an IP address (therefore ingress will be required on K8s) or 
    [] 2.1.2 a DNS name. (therefore consider using the native DNS services of the cloud provider)
  [] 3. This deployment must allow an operator to scale up or down the number of replicas
     [] 3.1 without too much effort (scripting manual process into a cli tool often helps here) 
      [] 3.1.1 It is not a basic requirement to implement the logic to automatically scale the application (so no scaling metrics server, and no autoscaling/hpa required in this implementation) 
      [] 3.1.2 It will be done by a human operator (... via configuration yaml and deployment scripts).

NOTE: Security, data resilience and monitoring have not been specified as part of this requirement, therefore: we will omit:

- Traffic encryption via SSL and SSL certificate management 
- logging/service monitoring components (e.g prometheus)
- AAA / Identity management (e.g AD integration to the app or AD based kubeconf access)
- backup of application data (dumping application db to storage)

Solution Architecture
=====================

- The Wordpress application and database will run as containers on a container orchestration platform.
- The container orchsetration platform will be deployed on cloud infrastructure.
- Native features of the orchestration platform will provide scalability scaling (manual or auto)
- HA will be provided by multiple replicas of the Application container behind a load-balancing service and auto-healing provided by the container platform
- Ease of scaling  and deployment will be provided by a single deployment and configuration script
- Database persistence will be provided by persistent volumes (which will in turn be provided by the containerisation platform)
- Public network connectivity will be provided via a load-balancer endpoint which routes traffic to the application service port over HTTP/S

Technical Implementation
=========================

[] 1. Launch/deployment will be done via shell script wrapping terraform and kubectl cli utilities
[] 2. Containerisation platform will be kubernetes (AKS)
[] 3. Wordpress will use a definition .yaml and app+db containers
[] 4. HA will be accomplished using replicas in a replicaset 
[] 5. IP reachability will be provided using an NGINX ingress
[] 6. DNS name will be implemented using Azures DNS service fronting ingress service end-point
[] 7. Scale up/down will be done using a script wrapping a configuration yaml (or simply just kubectl)
[] 8. For reproduceability, all code (infrastructure, platform etc ...) will be deployed from a versioning system (GitHub)

Optimisation notes
==================

[] A CD server (e.g jenkins) can be used to deploy the applications 
[] Autoscaling in response to inbound traffic load can be achieved by using Kubernetes Node scaling and HPA features.
[] Additional user-friendly deployment and update tools can be provided by wrapping the deployment scripts in a CD pipeline
[] Code and deployment quality can be improved by integrating continuous tests to a development environment using CI.
[] Data resilience can be achieved by adding a container and data backup solution e.g VMware Velero

