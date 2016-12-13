<%-- 
    Document   : viewEvents
    Created on : 4/05/2011, 09:09:04 PM
    Author     : Martha
--%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.platform.*,org.semanticwb.model.*,org.semanticwb.*,org.semanticwb.portal.resources.sem.calendar.*,java.util.*,org.semanticwb.portal.api.SWBResourceURL" %>
<%
    Resource base = paramRequest.getResourceBase();
    SWBResource wbBase = SWBPortal.getResourceMgr().getResource(base);
    SemanticObject objn = ((GenericSemResource)wbBase).getSemanticObject();
    org.semanticwb.portal.resources.sem.calendar.Calendar cal = (org.semanticwb.portal.resources.sem.calendar.Calendar) objn.createGenericInstance();
    User user = paramRequest.getUser();
    ArrayList roles = new ArrayList();
    String getRole1 = cal.getRoleForAdmin();
    while(getRole1 != null && getRole1.trim().length() > 1) {
        int num = getRole1.indexOf(",");
        if(num == -1 && getRole1.length() > 1) {
            roles.add(getRole1.trim());
            break;
        } else {
            String data1 = getRole1.substring(0, num);
            if(data1.trim().length() > 1) {
                roles.add(data1.trim());
            }
            num = num + 1;
            getRole1 = getRole1.substring(num ,getRole1.length());
            if(getRole1.indexOf(",") == -1) {
                if(getRole1.trim().length() > 1) {
                    roles.add(getRole1.trim());
                }
                break;
            }
        }
    }


if(user.getRole() != null && roles.contains(user.getRole().getId())) {

    SWBResourceURL url1 = paramRequest.getRenderUrl();
    SWBResourceURL url = paramRequest.getRenderUrl();
    url.setCallMethod(SWBResourceURL.Call_DIRECT); %>
<script type="text/javascript">
    function calculateEvents(page) {
        if (window.XMLHttpRequest) {
            peticion_http = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            peticion_http = new ActiveXObject("Microsoft.XMLHTTP");
        }
        var url = "<%=url.setMode("pagination")%>";

        url += "?pagen=" + escape(page);
        peticion_http.open('POST', url, true);
        peticion_http.onreadystatechange = function() {
            if ((peticion_http.readyState == 4) && (peticion_http.status == 200)) {
                var object = document.getElementById('listEvents');
                object.innerHTML = peticion_http.responseText;
            }
        }
        peticion_http.send(null);
    }
 </script>
<p class="linkG"><a href="<%=url1.setMode(SWBResourceURL.Mode_VIEW)%>"><%=paramRequest.getLocaleString("lb_return")%></a></p>
<p class="linkG"><a href="<%=url1.setMode("add").setParameter("_mode", "modAdd")%>"><%=paramRequest.getLocaleString("lb_addNewEvent")%></a></p>
<link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/css/calendar.css" rel="stylesheet" type="text/css" />
    <div class="headerListBox">
        <div class="listBox1"><span><%=paramRequest.getLocaleString("lb_titleEvt")%></span></div>
        <div class="listBox1"><span><%=paramRequest.getLocaleString("lb_startDate")%></span></div>
        <div class="listBox1"><span><%=paramRequest.getLocaleString("lb_endDate")%></span></div>
        <div class="listBox2"><span><%=paramRequest.getLocaleString("lb_options")%></span></div>
    </div>
    <div id="listEvents">
    </div>
<script type="text/javascript">
    <!--
            dojo.addOnLoad( function(){
                calculateEvents("0");}
            );
    -->
</script>
<% } %>