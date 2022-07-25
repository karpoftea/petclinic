# JWT Tokens
```shell
# export some static tokens
export TOKEN=$(curl https://raw.githubusercontent.com/istio/istio/release-1.14/security/tools/jwt/samples/demo.jwt -s)
export TOKEN_GROUP=$(curl https://raw.githubusercontent.com/istio/istio/release-1.14/security/tools/jwt/samples/groups-scope.jwt -s)

# show token
echo "$TOKEN_GROUP" | cut -d '.' -f2 - | base64 --decode -

# create custom JWT
git clone https://github.com/istio/istio.git
cd istio
git checkout release-1.14

python security/tools/jwt/samples/gen-jwt.py security/tools/jwt/samples/key.pem  -iss testing@secure.istio.io -aud petclinic-users -claims=email:mary@gmail.com,org:abracadabra -expire 4796658000000 -listclaim groups manager
export TOKEN_MANAGER="eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJwZXRjbGluaWMtdXNlcnMiLCJlbWFpbCI6Im1hcnlAZ21haWwuY29tIiwiZXhwIjo0Nzk4MzE1NDc1MDY1LCJncm91cHMiOlsibWFuYWdlciJdLCJpYXQiOjE2NTc0NzUwNjUsImlzcyI6InRlc3RpbmdAc2VjdXJlLmlzdGlvLmlvIiwib3JnIjoiYWJyYWNhZGFicmEiLCJzdWIiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyJ9.ube6MKxk0G1DpFpUCrdYbIOq9oB7giIsawbraVfIeGlAXqJBUhpDt7i5I6Z_i8GfzwIqyg42_d55r9D82A6-Zm1pLwE6AWSzvjJWKC5240xKLXGQqcJYT0rOBivysV2YM7cE3X0ocA5PZ1DPjpIaNTdBYEupY1Vi8KBEBx5ChKcI53XptQ4O8HRpwwrd56B3Tuci-tAih92pJnTOtG0F_xdq9cUFJhg9_TJEhpzZVMIXxC3d6vd9HfMkrI9STTgjLjX5GA6sIBOfHJEskZufEiy3VLl41rqciBXqLWINI0JVaI4pw4rxOtVBiRBPsAcnC1WiG0FWrHoZ6iCpD1FQiQ"

python security/tools/jwt/samples/gen-jwt.py security/tools/jwt/samples/key.pem  -iss testing@secure.istio.io -aud petclinic-users -claims=email:adam@gmail.com,org:abracadabra -expire 4796658000000 -listclaim groups admin
export TOKEN_ADMIN="eyJhbGciOiJSUzI1NiIsImtpZCI6IkRIRmJwb0lVcXJZOHQyenBBMnFYZkNtcjVWTzVaRXI0UnpIVV8tZW52dlEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJwZXRjbGluaWMtdXNlcnMiLCJlbWFpbCI6ImFkYW1AZ21haWwuY29tIiwiZXhwIjo0Nzk4MzE1NDc1MjgyLCJncm91cHMiOlsiYWRtaW4iXSwiaWF0IjoxNjU3NDc1MjgyLCJpc3MiOiJ0ZXN0aW5nQHNlY3VyZS5pc3Rpby5pbyIsIm9yZyI6ImFicmFjYWRhYnJhIiwic3ViIjoidGVzdGluZ0BzZWN1cmUuaXN0aW8uaW8ifQ.TJ1X0RUe-jt0_082DK0bGgIUKoAtg3QTA2TODjl43xNwp2F0Obxpqk5mIeYYj5QxQeUb0Y8bw2IwYpIn8Rl90nhn9CL2Lj2G3LT-1aTO6YvYW84qdPqfmA2tDfk1b0GBKRlwefc1tdGU4zS1rDRWKk4tRH56SyNLts__LmDo_TvPrp68C0BHhz0kuHTm_Ki1qTeY8XMere9iuiBZRx3J3J8pyJAcI5uH95OWyJGL1U5iZJhPb29eOVtR4pNF-ee2xqBQMBJdG7CZIbSVCBGmuRb5nXJynhpQj3WVMhZMVB5VFccrUsf5FYoZGzk52pTJDw7tty419KJ4ZsfdeoNsRg"
```

# Requests
```shell
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
 
curl "http://$INGRESS_HOST/owners/list"
curl --header "Authorization: Bearer deadbeef" "http://$INGRESS_HOST/owners/list"
curl --header "Authorization: Bearer $TOKEN" "http://$INGRESS_HOST/owners/list"

curl "http://$INGRESS_HOST/vets"
curl --header "Authorization: Bearer deadbeef" "http://$INGRESS_HOST/vets"
curl --header "Authorization: Bearer $TOKEN" "http://$INGRESS_HOST/vets"
```

# Auth0 OIDC
```shell
OIDC_DISCOVERY_URL="https://dev-jf-ctr97.us.auth0.com/.well-known/openid-configuration"
OIDC_DISCOVERY_URL_RESPONSE=$(curl $OIDC_DISCOVERY_URL)
OIDC_ISSUER_URL=$(echo $OIDC_DISCOVERY_URL_RESPONSE | jq -r .issuer)
OIDC_JWKS_URI=$(echo $OIDC_DISCOVERY_URL_RESPONSE | jq -r .jwks_uri)
```