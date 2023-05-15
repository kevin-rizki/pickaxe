

```
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

```
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8443:443 --address 0.0.0.0

kubectl port-forward -n tw-ha service/pgpool-svc-external 5432:5432 --address 0.0.0.0
```

https://<IP forwarder>:8443/#/login

[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

<!-- Cluster 149 -->
eyJhbGciOiJSUzI1NiIsImtpZCI6IkstRV9uX3lZN0JNZWNQeG9ZejZFMmlPNm5lNlpNcUhBRGw0ZndJbU5TMXMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLTQ3aHo1Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIyZDQ2MTQwZS0zZmFjLTQ1YjMtOWY0ZC0xMzM3Njg0NzRjYzIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.zH35KgpligtN83bmJGYr68pZ_p_S5OXHwvc3yLP2MxjXysx5-6MhX0VGQcgp5BJMmpRvSCTFPncfcnF4D_yi2yq5e1qE_JbEekfEP6Ti9nUUk6KGtjmTNzsgXJjhCiEgghv29i0Bd4ltwENtZ7d_pjobIy2i1NTlfTV2l8EziFW0QL9gBcXPI6dGciVm-MRY-z390sEP4YDKHKD57v-AJM5CjjLOySCymawtzwtvQITnD8xAC4R3NhMpOawJU61xO9ivaGJZgS0TjkAm4Ea8s0AiVB1l4YvhZtvIkdevXDWwyWuiH1ou8SJJAuaSfiryFhm-GCqr7VZd2sZI1SFEjQ