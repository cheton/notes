#### How to Build a Serverless App with S3 and Lambda in 15 Minutes
https://itnext.io/how-to-build-a-serverless-app-with-s3-and-lambda-in-15-minutes-b14eecd4ea89

#### Free Private NPM with Verdaccio and AWS
https://medium.com/@odahcam/free-private-npm-with-verdaccio-and-aws-a88e6f0f4beb

#### Automate Static Site Deployment on S3 with AWS CodeBuild
https://medium.com/@hzburki.hzb/automate-static-site-deployment-on-s3-with-aws-codebuild-8b2546a360df

#### React Continuous Deployments with AWS CodePipeline
https://medium.com/@jeffreyrussom/react-continuous-deployments-with-aws-codepipeline-f5034129ff0e

#### Deploy and host a ReactJS app with AWS Amplify Console
https://aws.amazon.com/getting-started/tutorials/deploy-react-app-cicd-amplify/

#### How to deploy your React App with AWS S3
https://medium.com/dailyjs/a-guide-to-deploying-your-react-app-with-aws-s3-including-https-a-custom-domain-a-cdn-and-58245251f081

#### CloudFront Design Patterns And Best Practices
https://www.abhishek-tiwari.com/cloudfront-design-patterns-and-best-practices/

#### Terraform Recommended Practices
https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html

#### Use Slack ChatOps to Deploy Your Code – How to Integrate Your Pipeline in AWS CodePipeline with Your Slack Channel
https://aws.amazon.com/tw/blogs/devops/use-slack-chatops-to-deploy-your-code-how-to-integrate-your-pipeline-in-aws-codepipeline-with-your-slack-channel/


#### How to make CloudFront never cache index.html on S3 bucket
https://stackoverflow.com/questions/45727454/how-to-make-cloudfront-never-cache-index-html-on-s3-bucket

A solution based on CloudFront configuration:

Go to your CloudFront distribution, under the "Behavior" tab and create a new behavior. Specify the following values:

Path Pattern: index.html
Object Caching: customize
Maximum TTL: 0 (or another very small value)
Default TTL: 0 (or another very small value)
Save this configuration.

CloudFront will not cache index.html anymore.
