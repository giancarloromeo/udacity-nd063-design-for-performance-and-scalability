Initial Cost Estimation
Total Monthly: 8,370.98 USD
https://calculator.aws/#/estimate?id=808e7c44b7465b6a8ad6bc02720c8104892990ea



Reduced Cost Estimation
- EC2 Instance Type: c5.12xlarge => c5.2xlarge

Due to limited budget, EC2 Instance Types are downgraded to a cheaper family with lower performance.

Total Monthly: 6,232.37 USD
https://calculator.aws/#/estimate?id=0ae4a01ecb57d5e40c1eab32f214de276e40cae4



Increased Cost Estimation
- EC2 Instance Quantity: 4 => 6
- RDS Quantity: 1 => 2 (with multi A-Z replicas)
- S3 Standard storage: 1 => 10 TB per month

Added replicas to RDS storage/size to support higher amount of data. 
Added EC2 Instances to handle more requests/traffic.
Updated S3 Storage to adapt to more space needed.

Total Monthly: 18,032.18 USD
https://calculator.aws/#/estimate?id=120e9ad0a0db1a16d14bfa79929c382f84fd6ecd
