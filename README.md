# 1panel_ssl_cert_uploader

a action for upload ssl cert from github actions to 1panel

## Acknowledgements

I would like to express my gratitude to the following individuals and organizations:

- [ColinZeb](https://github.com/ColinZeb) for his script in [#discussioncomment-10932704](https://github.com/1Panel-dev/1Panel/discussions/6299#discussioncomment-10932704).




## example

```
# if you enable mfa
- name: Generate auth code
  id: generate
  uses: nknguyengl/totp-generator@v1.0.0
  with:
    totp_key: ${{ secrets.MFA_KEY }}


- uses: dextercai/1panel_ssl_cert_uploader@main
  with:
    username: "username"
    password: ${{ secrets.PASSWORD }}
    entrance_code: "example_code" # optional
    mfa_token: ${{ steps.generate.outputs.code }} # optional
    login_url: "http://example.com/api/v1/auth/login"
    mfa_login_url: "http://example.com/api/v1/auth/mfalogin"
    upload_url: "http://example.com/api/v1/websites/ssl/upload"
    ssl_id: 1
    description: "sync from actions"
    private_key_path: ./_.example.com.key
    certificate_path: ./_.example.com.pem

```