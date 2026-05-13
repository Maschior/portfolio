# 1. Install Docker

# 2. Run
```
cd terraform/out/
```

# 2. Run
```
docker run --rm -it -p 9000:9000 -v $(pwd)/plan.json:/src/plan.json im2nguyen/rover:latest -planJSONPath=plan.json
```