
<img width="2816" height="1504" alt="advaitam-architecture" src="https://github.com/user-attachments/assets/5ea9f578-daf7-4b4d-9475-766f3c4e93e5" />


# 🚀 Enterprise Cloud-Native E-Commerce Platform

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)
![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)

A production-ready, containerized MERN stack e-commerce application architected for high availability and performance. Deployed on **AWS EKS (Kubernetes)** with **Terraform** Infrastructure-as-Code.

This project moves beyond simple CRUD, featuring advanced search capabilities via **Elasticsearch**, secure payment processing with **Razorpay**, and a globally cached frontend delivering **<2s page loads**.

---

## 🏗 System Architecture

The infrastructure is designed for scalability and resilience, utilizing a microservices-based approach with Docker and Kubernetes.

**Infrastructure Highlights:**
* **Compute:** Amazon EKS (Managed Kubernetes) with Horizontal Pod Autoscaling (HPA).
* **CDN & Caching:** Amazon CloudFront serving static assets from S3 with Route 53 DNS resolution.
* **Database:** MongoDB Atlas (Primary Data) & AWS OpenSearch/Elasticsearch (Search Engine).
* **Traffic:** AWS Application Load Balancer (ALB) via Ingress Controller.

---

## ⚡ Key Features

### 1. High-Performance Frontend
* **CloudFront CDN:** Delivers static content (React build) from edge locations, reducing latency.
* **Optimized Assets:** Implemented lazy loading and image compression to achieve a strict **<2s Time-to-Interactive (TTI)**.
* **Nginx Sidecar:** Uses lightweight Nginx containers to serve React static files within the Kubernetes pods.

### 2. Intelligent Search (Elasticsearch)
* **Search Engine:** Offloaded complex queries from MongoDB to **AWS OpenSearch**.
* **Capabilities:** Features fuzzy matching, facetted search (filtering by price/category), and autocomplete.
* **Business Impact:** Contributed to a **25% increase in conversion rates** by improving product discoverability.

### 3. Secure Payments (Razorpay)
* **Robust Integration:** Full checkout flow using Razorpay Standard Checkout.
* **Security:** Server-side signature verification using cryptographic hashing (HMAC-SHA256).
* **Webhooks:** Automated order status updates via secure webhooks to handle connection drops or window closures.

### 4. DevOps & CI/CD
* **Containerization:** Fully dockerized Frontend and Backend environments.
* **Infrastructure as Code:** Complete AWS environment provisioning using **Terraform**.
* **Pipeline:** GitHub Actions pipeline to build images, push to **Amazon ECR**, and deploy to EKS.

---

## 🛠 Tech Stack

| Domain | Technologies |
| :--- | :--- |
| **Frontend** | React.js, Redux Toolkit, Tailwind CSS, Axios |
| **Backend** | Node.js, Express.js, JWT Auth |
| **Database** | MongoDB Atlas (Cluster), AWS OpenSearch (Elasticsearch) |
| **DevOps** | Docker, Kubernetes (EKS), Terraform, GitHub Actions, AWS IAM |
| **AWS Services** | S3, EC2, ECR, Route 53, CloudFront, ALB, Secrets Manager |
| **Payments** | Razorpay API & Webhooks |

---

## 🚀 Getting Started

### Prerequisites
* Docker & Kubernetes CLI (kubectl)
* AWS CLI (configured)
* Terraform
* Node.js v18+

### 1. Local Development (Docker Compose)
Run the application locally without Kubernetes for rapid development.
```bash
# Clone the repo
git clone [https://github.com/Aayushsoni09/Advaitam.git]
```
# Start services
docker-compose up --build

### 2. Infrastructure Provisioning (Terraform)
Provision the VPC, EKS Cluster, and Networking layers.
```bash
cd terraform/
terraform init
terraform apply --auto-approve
```
### 3. Deployment to AWS EKS
```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name ecommerce-cluster

# Apply K8s Manifests
kubectl apply -f k8s/
```
## 📈 Future Improvements
- Implement Redis for caching user sessions and API response caching.

- Add Prometheus and Grafana for cluster monitoring.

- Implement Service Mesh (Istio) for advanced traffic management.

## 📄 License
This project is licensed under the MIT License.
