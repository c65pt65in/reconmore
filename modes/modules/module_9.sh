#!/bin/bash

dir=/usr/share/reconmore/reports/$2
if [ ! -d $dir ]
then
mkdir $dir 
fi
echo -e "\e[32mStarting Module 9-Checking web application vulnerabilities...\e[0m" | tee -a $dir/report
path="/usr/share/reconmore/arachni-1.6.1.3-0.6.1.1/bin/arachni"
url="https://${1}"
if ! curl -s -m 5 $url >/dev/null
then
url="http://${1}" 
fi
sudo -u www-data $path --output-only-positives --browser-cluster-pool-size 6 --browser-cluster-ignore-images $url --report-save-path /tmp/arachni.afr --checks=csrf,code-injection*,ldap_injection,path_traversal,file_inclusion,response_splitting,os_cmd-injection*,rfi,unvalidated_redirect*,xpath_injection,xss*,source_code_disclosure,xxe,backup_files,backup_directories,common_admin_interfaces,common_directories,http_put,unencrypted_password_forms,webdav,xst,cvs_svn_users,htaccess_limit,interesting_responses,html_objects,mixed_resource,insecure_cookies,http_only_cookies,password_autocomplete,form_upload,cookie_set_for_parent_domain --scope-directory-depth-limit 5 2>/dev/null 
sudo -u www-data /usr/share/reconmore/arachni-1.6.1.3-0.6.1.1/bin/arachni_reporter /tmp/arachni.afr >> $dir/report
sudo -u www-data rm -f /tmp/arachni.afr
report=$(cat $dir/report)
if [[ $report == *"Cross-Site Request Forgery"* ]]
then
echo -e "\e[31mCross-Site Request Forgery: User requests about very important actions should include CSRF tokens that are random, tied to the users session and validated properly from the server!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Code injection"* ]] || [[ $report == *"Code injection (timing attack)"* ]]
then
echo -e "\e[31mCode injection: Untrusted user inputs should never be processed by the server and in case this cannot be avoided then there should be strict validation by whitelisting specific values!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"LDAP Injection"* ]]
then
echo -e "\e[31mLDAP Injection: Untrusted data in LDAP queries must be escaped, frameworks that protect from LDAP injection can be used, the principle of least privilege should be followed and there should be a list input validation prior to the execution of LDAP query!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Path Traversal"* ]]
then
echo -e "\e[31mPath Traversal: User input should not be used for file location calls, there should be a whitelist of permitted files and sensitive files should not be stored in the web root!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"File Inclusion"* ]]
then
echo -e "\e[31mFile Inclusion: User input should not be used for file location calls, there should be a whitelist of permitted files and sensitive files should not be stored in the web root!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Response Splitting"* ]]
then
echo -e "\e[31mResponse Splitting: Untrusted data should never be used to form the contents of a response header!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Operating system command injection"* ]] || [[ $report == *"Operating system command injection (timing attack)"* ]]
then
echo -e "\e[31mOperating system command injection: The direct execution of operating system commands from inside the web application must be avoided. If it cannot be avoided then this functionality should be performed by secure APIs with strong input validation!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Remote File Inclusion"* ]]
then
echo -e "\e[31mRemote File Inclusion: User input should not be used for file location calls, there should be a whitelist of permitted files and sensitive files should not be stored in the web root!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Unvalidated redirect"* ]] || [[ $report == *"Unvalidated DOM redirect"* ]]
then
echo -e "\e[31mUnvalidated redirect: Redirection functions with inputs should be replaced by direct links and a list with allowed redirection URLs should be maintained and checked server-side!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"XPath Injection"* ]]
then
echo -e "\e[31mXPath Injection: User input should be validated and in most cases should include only alphanumeric strings!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Cross-Site Scripting (XSS)"* ]] || [[ $report == *"DOM-based Cross-Site Scripting (XSS)"* ]]|| [[ $report == *"DOM-based Cross-Site Scripting (XSS) in script context"* ]] || [[ $report == *"Cross-Site Scripting (XSS) in event tag of HTML element"* ]] || [[ $report == *"Cross-Site Scripting (XSS) in path"* ]] || [[ $report == *"Cross-Site Scripting (XSS) in script context"* ]] || [[ $report == *"Cross-Site Scripting (XSS) in HTML tag"* ]]
then
echo -e "\e[31mCross-Site Scripting (XSS): Untrusted user inputs must not placed directly to a script or in css, inside an HTML comment, an attribute name or a tag name. In specific cases where untrusted data is output in HTML or javascript contexts it should be encoded in order to avoid being interpreted as active content. Also, XSS attacks may be prevented by using appropriate HTTP response headers such as “Content-Type”,“X-Content-Type-Options” and Content-Security-Policy (CSP)!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Source code disclosure"* ]]
then
echo -e "\e[31mSource code disclosure: Sensitive application files must have proper permissions that prevent access from public users and they must not placed inside the web root!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"XML External Entity"* ]]
then
echo -e "\e[31mXML External Entity: The XML features that are not intended to be used by the XML processor should be disabled and disable the support of external entities!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Backup file"* ]]
then
echo -e "\e[31mBackup file: Backup files should not be kept inside the web root!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Backup directory"* ]]
then
echo -e "\e[31mBackup directory: Unnencessary directories should not be available in a website or web application!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Common administration interface"* ]]
then
echo -e "\e[31mCommon administration interface: The administrator interfaces should be visited only by those in allowed access control lists!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Common directory"* ]]
then
echo -e "\e[31mCommon directory: Directories that are not used should be removed!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Publicly writable directory"* ]]
then
echo -e "\e[31mPublicly writable directory: The HTTP PUT method should be disabled on the server!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Unencrypted password form"* ]]
then
echo -e "\e[31mUnencrypted password form: The website or web application should function with the latest secure encryption protocols (SSL,TLS)!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"WebDAV"* ]]
then
echo -e "\e[31mWebDAV: WebDAV provides functionalities that are too risky and not so secure and it should be disabled!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"HTTP TRACE"* ]]
then
echo -e "\e[31mHTTP TRACE: The HTTP TRACE method in most cases is not needed and should be disabled!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"CVS/SVN user disclosure"* ]]
then
echo -e "\e[31mCVS/SVN user disclosure: SVN/CVS files should be removed prior to development!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Misconfiguration in LIMIT directive of .htaccess file"* ]]
then
echo -e "\e[31mMisconfiguration in LIMIT directive of .htaccess file: It is better to follow a whitelist approach with the 'LimitExcept' directive in order not to forget which methods to disable by blacklisting!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Interesting response"* ]]
then
echo -e "\e[31mInteresting response: HTTP responses should leak the least informations!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"HTML object"* ]]
then
echo -e "\e[31mHTML object: Untrusted user inputs must not placed directly to a script or in css, inside an HTML comment, an attribute name or a tag name. In specific cases where untrusted data is output in HTML or javascript contexts it should be encoded in order to avoid being interpreted as active content. Also, XSS attacks may be prevented by using appropriate HTTP response headers such as “Content-Type”,“X-Content-Type-Options” and Content-Security-Policy (CSP)!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Mixed Resource"* ]]
then
echo -e "\e[31mMixed Resource: All pages and resources should utilize HTTPS!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Insecure cookie"* ]]
then
echo -e "\e[31mInsecure cookie: Cookies that contain sensitive informations should have the 'Security' attribute set in order to only be sent when HTTPS is used!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"HttpOnly cookie"* ]]
then
echo -e "\e[31mHttpOnly cookie: If cookies don’t need to be accessed by any client side scripts then the HTTPOnly attribute should be set!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Password field with auto-complete"* ]]
then
echo -e "\e[31mPassword field with auto-complete: The 'autocomplete' attribute in HTML forms should be disabled!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Form-based File Upload"* ]]
then
echo -e "\e[31mForm-based File Upload: The files should be validated prior to the upload and if possible a framework is better to be used rather a custom validation mechanism. They should be validated regarding the extension, name and size and the prefferred HTTP upload method  should be 'POST'!\e[0m" | tee -a $dir/report
fi
if [[ $report == *"Cookie set for parent domain"* ]]
then
echo -e "\e[31mCookie set for parent domain: In most situations it is recommended to omit the 'Domain' attribute in cookies!\e[0m" | tee -a $dir/report
fi
echo -e "\e[31mReport saved at $dir.\e[0m"
