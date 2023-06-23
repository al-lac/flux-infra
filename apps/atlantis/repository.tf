---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: atlantis
  namespace: atlantis
spec:
  interval: 10m
  url: https://runatlantis.github.io/helm-charts
