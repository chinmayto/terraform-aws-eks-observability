#!/bin/bash

# Simple deployment script for Example Voting App
# Deploys all manifests and sets up port forwarding

set -e

echo "🚀 Deploying Example Voting App to Kubernetes..."

# Deploy all manifests
echo "📦 Applying Kubernetes manifests..."
kubectl apply -f .

echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=vote --timeout=120s
kubectl wait --for=condition=ready pod -l app=result --timeout=120s
kubectl wait --for=condition=ready pod -l app=redis --timeout=120s
kubectl wait --for=condition=ready pod -l app=db --timeout=120s
kubectl wait --for=condition=ready pod -l app=worker --timeout=120s

echo "✅ All pods are ready!"

echo "🌐 Setting up port forwarding..."
echo "Vote app will be available at: http://localhost:8080"
echo "Result app will be available at: http://localhost:8081"
echo ""
echo "Press Ctrl+C to stop port forwarding and exit"
echo ""

# Start port forwarding in background
kubectl port-forward service/vote 8080:8080 &
VOTE_PID=$!

kubectl port-forward service/result 8081:8081 &
RESULT_PID=$!

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping port forwarding..."
    kill $VOTE_PID $RESULT_PID 2>/dev/null || true
    echo "👋 Goodbye!"
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

# Wait for user to press Ctrl+C
echo "✨ Port forwarding is active. Open your browser to:"
echo "   Vote:   http://localhost:8080"
echo "   Result: http://localhost:8081"
echo ""

# Keep script running
wait