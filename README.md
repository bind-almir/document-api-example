**Documenting Serverless API**

There are many great languages and tools in the wild that can help you to create and document API's. In this article we are going to focus on AWS API Gateway, serverless framework, serverless documentation plugin, Swagger UI and some shell scripting. 

Read more [here](https://almirzulic.com/posts/documenting-serverless-api/).

** Instructions **

- You'll need an Amazon Web Services account and credentials set up on your development machine. If you haven't done it before, here's a useful guide for [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
- [Configure AWS credentials](https://serverless.com/framework/docs/providers/aws/guide/credentials/) to use with serverless framework.
- Install [NodeJS](https://nodejs.org) 
- Install [serverless](https://serverless.com/) framework using `npm i -g serverless`
- Clone this repository `git clone https://github.com/bind-almir/document-api-example.git`
- Change directory to project dir `cd document-api-example.git`
- Install dependencies `npm i`
- To deploy API run `sls deploy --stage dev --region YOUR_REGION`
- run `./deploy.sh --bucket=YOUR_S3_BUCKET --region=YOUR_REGION --gateway=YOUR_API_GATEWAY_ID`
