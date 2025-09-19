# 1panel_ssl_cert_uploader

a action for upload ssl cert from github actions to 1panel

please use 1panel v1.10.24+    
also compatible with 1panel v2                                                         

## Acknowledgements

I would like to express my gratitude to the following individuals and organizations:

- [ColinZeb](https://github.com/ColinZeb) for his script in [#discussioncomment-10932704](https://github.com/1Panel-dev/1Panel/discussions/6299#discussioncomment-10932704).

## example

```yaml
- uses: dextercai/1panel_ssl_cert_uploader@main
  with:
    login_url: "http://example.com/api/v1/auth/login"
    upload_url: "http://example.com/api/v1/websites/ssl/upload"
    ssl_id: 1
    description: "sync from actions"
    private_key_path: ./_.example.com.key
    certificate_path: ./_.example.com.pem
    api_key: ${{ secrets.API_KEY }}
```
