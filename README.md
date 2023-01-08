# Deploy Custom FastAPI + PyTorch Container on AWS SageMaker (GPU) 

This repository shows an example on how we can deploy a custom Docker container running on GPU instances on AWS SageMaker. We will deploy a pretrained [YOLOv5](https://github.com/ultralytics/yolov5) object detector model in this example. We have chosen [FastAPI](https://fastapi.tiangolo.com/) for building real-time serving endpoints, a more performant framework as compared to the standard [Nginx + Gunicorn + Flask stack](https://sagemaker-examples.readthedocs.io/en/latest/advanced_functionality/scikit_bring_your_own/scikit_bring_your_own.html#Running-your-container-during-hosting). 

# AWS Services
1. AWS SageMaker
2. AWS Elastic Container Registry (ECR)

# Overview
1. Login to ECR, pull the required [AWS Deep Learning Container (DLC)](https://github.com/aws/deep-learning-containers/blob/master/available_images.md#sagemaker-framework-containers-sm-support-only) with SageMaker support
2. Extend and build DLC image with additional dependencies
3. Push built Docker Image to ECR and deploy

# Getting Started

## Prerequisites

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [AWS Multi-Factor Authentication](https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/)
* [Docker Engine](https://docs.docker.com/engine/install/)

## Installation

1. Retrieve AWS MFA token via AWS CLI

    To authenticate to your AWS resources, refer to: https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/

2. Login to Elastic Container Registry
    ```
    aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 763104351884.dkr.ecr.ap-southeast-1.amazonaws.com
    ```

3. Build Docker Image
    ```
    docker build  -t <AWS Account ID>.dkr.ecr.<AWS REGION>.amazonaws.com/fastapi-yolov5 .
    ```

4. Push Docker Image to AWS Elastic Container Registry
    ```
    docker push <AWS Account ID>.dkr.ecr.<AWS REGION>.amazonaws.com/fastapi-yolov5
    ```

## Deploy

### 1. Create a model in AWS Sagemaker

1. Navigate to Amazon SageMaker > Inference > Models
2. Click on **Create model**
3. Under **Model settings**, provide a Model name and IAM role with sufficient permissions
4. Under **Container definition 1** > **Provide model artifacts and inference image options**, select **Use a single model** and fill in **Location of inference code image** with the built container stored in ECR
5. Click on **Create model** to complete this step

### 2. Create an endpoint configuration

1. Navigate to Amazon SageMaker > Inference > Endpoint configurations
2. Click on **Create endpoint configuration**
3. Under **Endpoint configuration**, provide an Endpoint configuration name
4. Under **Production variants**, click on **Add model** and select the model that was created in the previous step
5. A new row should be created under **Production variants**, click on **Edit** under the **Actions** column
6. Under **Instance type**, select an apprioriate EC2 instance, we recommend the ml.g4dn.xlarge as it is the cheapest GPU instance
7. Click on **Create endpoint configuration** to complete this step

### 3. Deploy

1. Navigate to Amazon SageMaker > Inference > Endpoints
2. Click on **Create endpoint**
3. Under **Endpoint name**, provide an appropriate name for the endpoint
4. Under **Endpoint configuration**, select the Endpoint configuration that was created in the previous step and click on **Select endpoint configuration**
5. Click on **Create endpoint** to complete this step

# Limitations

The limitations were mainly affecting GPU deployments. As of time of writing, AWS SageMaker only allows:

1. A single container to be deployed on a GPU instance to avoid resource contention
2. A single model to be deployed within a single container on GPU instances

# Acknowledgements
* [FastAPI](https://github.com/tiangolo/fastapi)
* [YOLOv5 by Ultralytics](https://github.com/ultralytics/yolov5)
