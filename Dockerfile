FROM 763104351884.dkr.ecr.ap-southeast-1.amazonaws.com/pytorch-inference:1.10.2-gpu-py38-cu113-ubuntu20.04-sagemaker

# Copy source code
COPY /src /opt/program

# Install dependencies
RUN pip install -r /opt/program/requirements.txt

# Configure ENV variables
# set FORCE_CUDA because during `docker build` cuda is not accessible
ENV FORCE_CUDA="1"
ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# nvidia-runtime ENV configurations from: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

RUN chmod 755 /opt/program

WORKDIR /opt/program

EXPOSE 8080

ENTRYPOINT ["bash", "entrypoint.sh"]