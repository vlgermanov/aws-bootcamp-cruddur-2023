# Week 1 — App Containerization

## 1. Required Homework

### 1.1. Review of the week's videos

- [x] Watched: [How to Ask for Technical Help](https://www.youtube.com/watch?v=tDPqmwKMP7Y&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=29)
- [x] Watched: [Grading Homework Summaries](https://www.youtube.com/watch?v=FKAScachFgk&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=25)
- [x] Watched: [Week 1 - Live Streamed Video](https://www.youtube.com/watch?v=zJnNe5Nv4tE&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=22)
- [x] Watched: [Remember to Commit Your Code](https://www.youtube.com/watch?v=b-idMgFFcpg&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=23)
- [x] Watched: [Chirag's Week 1 - Spending Considerations](https://www.youtube.com/watch?v=OAMHu1NiYoI&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=24)
- [x] Watched: [Ashish's Week 1 - Container Security Considerations](https://www.youtube.com/watch?v=OjZz4D0B-cA&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=25)
- [x] Watched: [Containerize Application (Dockerfiles, Docker Compose)](https://www.youtube.com/watch?v=zJnNe5Nv4tE&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=22)
- [x] Watched: [Document the Notification Endpoint for the OpenAI Document](https://www.youtube.com/watch?v=k-_o0cCpksk&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=27)
> **Note:**
> [OpenAPI Specification v3.1.0](https://spec.openapis.org/oas/v3.1.0)
- [x] Watched: [Write a Flask Backend Endpoint for Notifications](https://www.youtube.com/watch?v=k-_o0cCpksk&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=27)
- [x] Watched: [Write a React Page for Notifications](https://www.youtube.com/watch?v=k-_o0cCpksk&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=27) 
> **Note:**
> Registration's confirmation code `hardcoded` to '1234'
- [x] Watched: [Run DynamoDB Local Container and ensure it works](https://www.youtube.com/watch?v=CbQNMaa6zTg&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=28)
- [x] Watched: [Run Postgres Container and ensure it works](https://www.youtube.com/watch?v=CbQNMaa6zTg&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=28)

### 1.2. Containerize the applications

#### 1.2.1. Backend-flask

- Created a [Dockerfile](../backend-flask/Dockerfile)

```dockerfile
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE 4567

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
```

- Test `docker build`

```shell
gitpod /workspace/aws-bootcamp-cruddur-2023/backend-flask (main) $ docker build -t backend-flask:test .
Sending build context to Docker daemon  33.79kB
Step 1/8 : FROM python:3.10-slim-buster
 ---> 934047247b20
Step 2/8 : WORKDIR /backend-flask
 ---> Running in db01081dadcc
Removing intermediate container db01081dadcc
 ---> 84c3ed779f2b
Step 3/8 : COPY requirements.txt requirements.txt
 ---> 420141812611
Step 4/8 : RUN pip3 install -r requirements.txt
 ---> Running in f644ece4d265
Collecting flask
  Downloading Flask-2.2.3-py3-none-any.whl (101 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 7.1 MB/s eta 0:00:00
Collecting flask-cors
  Downloading Flask_Cors-3.0.10-py2.py3-none-any.whl (14 kB)
Collecting Werkzeug>=2.2.2
  Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 33.3 MB/s eta 0:00:00
Collecting Jinja2>=3.0
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 49.2 MB/s eta 0:00:00
Collecting click>=8.0
  Downloading click-8.1.3-py3-none-any.whl (96 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.6/96.6 kB 37.2 MB/s eta 0:00:00
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
Collecting Six
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Installing collected packages: Six, MarkupSafe, itsdangerous, click, Werkzeug, Jinja2, flask, flask-cors
Successfully installed Jinja2-3.1.2 MarkupSafe-2.1.2 Six-1.16.0 Werkzeug-2.2.3 click-8.1.3 flask-2.2.3 flask-cors-3.0.10 itsdangerous-2.1.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip available: 22.3.1 -> 23.0.1
[notice] To update, run: pip install --upgrade pip
Removing intermediate container f644ece4d265
 ---> af551f3164ca
Step 5/8 : COPY . .
 ---> ba7a4fb6d899
Step 6/8 : ENV FLASK_ENV=development
 ---> Running in 555d0da1d10f
Removing intermediate container 555d0da1d10f
 ---> 55b4d21213f9
Step 7/8 : EXPOSE 4567
 ---> Running in 00979636d271
Removing intermediate container 00979636d271
 ---> 088a9e47f6ae
Step 8/8 : CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
 ---> Running in 21e7fcbc4e54
Removing intermediate container 21e7fcbc4e54
 ---> 2b2dee66d340
Successfully built 2b2dee66d340
Successfully tagged backend-flask:test
gitpod /workspace/aws-bootcamp-cruddur-2023/backend-flask (main) $ docker image ls
REPOSITORY      TAG                IMAGE ID       CREATED         SIZE
backend-flask   test               2b2dee66d340   4 seconds ago   129MB
python          3.10-slim-buster   934047247b20   20 hours ago    118MB
gitpod /workspace/aws-bootcamp-cruddur-2023/backend-flask (main) $ docker rmi backend-flask:test 
Untagged: backend-flask:test
Deleted: sha256:2b2dee66d340116d2be3be2b21b4e2a64be544393f156688c46a1572e75411f9
Deleted: sha256:088a9e47f6aea017edaaa6928f2634c4dc36460de18dbc20fb8274a27a396842
Deleted: sha256:55b4d21213f9ba5b5f9cd49f9ee031533b90925f7426f4114ae213c82ac3129e
Deleted: sha256:ba7a4fb6d899e7a69786a4bc9e1989c5af325ffb16ffd43c2ef249860101c130
Deleted: sha256:eb305886f1a16742ee92401c6a3f7efc816bd0d8cf3cc4b697ba9ae2cb9d0a92
Deleted: sha256:af551f3164ca23b620f150caf75e2a41d9f6977103286799ac21d06125f8b70d
Deleted: sha256:68681d7346b9d0debfc5ced1ba32ff7466a9752775ede623e3d91727c42cafeb
Deleted: sha256:4201418126111b2652d8ef216f455b204a834fa3f8edb0cc9f3d3e1a5d8cc42f
Deleted: sha256:9ad4f2cb5c082f0faba9f6ad23c10cb4321135ea672601542e1bd7d836cdb820
Deleted: sha256:84c3ed779f2b27eb568c10ef639cf0ede5f96369b976745d7314d01d160e8820
Deleted: sha256:37bbcdab0d7c28d203ad79a2d848fc87a38f843ef2e78e1f330fc554168c6281
```

![image](../_docs/assets/week-1/backend-flask-docker-build-test.png)

### 1.3. Notifications functionality in the applications

### 1.4. Run locally DB containers

## 2. Stretched Homework

### 2.1. Build and publish container's images to DockerHub

### 2.2. Multi-stage builds for container images

### 2.3. Implement a `health check` in the docker-compose file

### 2.4. Install docker on my local machine and run the applications locally

### 2.5. Launch an EC2 instance with docker installed and lunch the apps there

### 2.6. Best practices of `Dockerfiles`
