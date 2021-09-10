FROM alpine:3.13

LABEL version="1.0.0"
LABEL name="helm-secrets-eks-action"
LABEL repository="https://github.com/denimar/helm-secrets-eks-action"
LABEL homepage="https://github.com/denimar/helm-secrets-eks-action"

LABEL maintainer="Denimar de Moraes <denimar@gmail.com>"
LABEL com.github.actions.name="Kubectl, Helm, Helm Secrets and EKS"
LABEL com.github.actions.description="Kubectl + Helm + Helm Secrets to work with AWS EKS"
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

RUN apk add py-pip curl wget ca-certificates git bash jq gcc alpine-sdk
RUN pip install 'awscli==1.20.8'

RUN apk add --no-cache curl
RUN curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x /usr/bin/aws-iam-authenticator

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]