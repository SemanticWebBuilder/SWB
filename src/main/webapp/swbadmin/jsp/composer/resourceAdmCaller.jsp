<%-- 
    Document   : resourceAdmCaller
    Created on : Jul 30, 2019, 1:29:39 PM
    Author     : jose-jimenez
--%>

<%@page import="org.semanticwb.portal.admin.resources.SWBAComposer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.SWBPortal,
        org.semanticwb.SWBPlatform, org.semanticwb.model.SWBContext, org.semanticwb.model.User,
        java.util.Locale, org.semanticwb.model.WebPage, org.semanticwb.portal.api.SWBResource"%>
<%
    User user = SWBContext.getAdminUser();
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    String resId = request.getParameter("resId");
    SWBResource res = null;
    String path = null;
    String webSiteId = request.getParameter("webSiteId");
    System.out.println("websiteId: " + webSiteId + "\nresourceId: " + resId);
    if (null == user) {
        response.sendError(403);
        return;
    }
    if (null != resId && !"".equals(resId)) {
        res = SWBPortal.getResourceMgr()
                .getResource(webSiteId, resId);
        System.out.println("res:" + res.toString());
        path = SWBPlatform.getContextPath() + "/" + user.getLanguage() +
            "/SWBAdmin/bh_AdminPorltet?suri=" + res.getResourceBase().getEncodedURI();
    }
    
%>
<%-- form >
    <button type="button" onclick="window.history.back();" name="back">Regresar</button>
< / form --%>
<%
    System.out.println("path: " + path);
    if (null != path) {
%>
<iframe id="admFrame" src="<%=path%>" style="border:none;"></iframe>
<%
    }
%>
<script type="text/javascript">
    let bodyWidth = document.querySelector(".modalW-dialog").offsetWidth;
    let bodyHeight = document.querySelector(".modalW-dialog").offsetHeight;
    let frameElem = document.getElementById("admFrame");
    frameElem.width = bodyWidth * .95;
    frameElem.height = bodyHeight * .90;
</script>
