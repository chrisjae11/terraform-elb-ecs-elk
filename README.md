# elb-ecs-nginx-kibana

## Settings

#### Step 1.
Insert the correct values in terraform.tfvars

#### Step 2.
Insert existing kibana url in docker/nginx.conf:
```
location /_plugin/kibana {
    proxy_pass https://vpc-test-4vydnpzm7efhrxrpg4v7vkub3e.eu-central-1.es.amazonaws.com/_plugin/kibana/;
}
```
#### Step 3.
run:
```terraform apply```