<%-- 
    Document   : resourceAdmCaller
    Created on : Jul 30, 2019, 1:29:39 PM
    Author     : jose-jimenez
--%>

<%@page import="org.semanticwb.portal.admin.resources.SWBAComposer"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.SWBPortal,
        org.semanticwb.SWBPlatform, org.semanticwb.model.*, 
        java.util.Locale, org.semanticwb.model.base.*, org.semanticwb.portal.api.*,
        org.semanticwb.portal.resources.sem.HTMLContent, org.semanticwb.platform.*"%>
<%
    User user = SWBContext.getAdminUser();
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    String resId = request.getParameter("resId");
    SWBResource res = null;
    String path = null;
    String webSiteId = request.getParameter("webSiteId");
    String resType = request.getParameter("resType"); //htmlContent
    
    System.out.println("websiteId: " + webSiteId + "\nresourceId: " + resId);
    
    if (null == user) {
        response.sendError(403);
        return;
    }
    if (null != resId && !"".equals(resId) && (null == resType || !"htmlContent".equals(resType))) {
        //Despliegue de la administracion de los recursos de SWB
        res = SWBPortal.getResourceMgr()
                .getResource(webSiteId, resId);
        System.out.println("res:" + res.toString());
        path = SWBPlatform.getContextPath() + "/" + user.getLanguage() +
            "/SWBAdmin/bh_AdminPorltet?suri=" + res.getResourceBase().getEncodedURI();
    } else if (null != resType && "htmlContent".equals(resType)) {
        //Despliegue del modo edicion para los contenidos de HTML
        res = SWBPortal.getResourceMgr()
                .getResource(webSiteId, resId);
        
        SemanticOntology ont = SWBPlatform.getSemanticMgr().getOntology();
        SemanticObject obj = ont.getSemanticObject(res.getResourceBase().getURI());
        SemanticClass cls = obj.getSemanticClass();
        SemanticObject aux = obj;
        
        Resource simpleRes = (Resource) obj.createGenericInstance();
        SWBResource swbres = SWBPortal.getResourceMgr().getResource(simpleRes);
        SemanticObject robj= ((GenericSemResource) swbres).getSemanticObject();
        if (robj != null) {
            aux = robj;
        }
        System.out.println("Resource uri: " + aux.getEncodedURI());
        
        path = SWBPlatform.getContextPath() + "/" + user.getLanguage() +
            "/SWBAdmin/EditVersionWithDojo?suri=" + aux.getEncodedURI();
    }
    
%>
<%-- form >
    <button type="button" onclick="window.history.back();" name="back">Regresar</button>
< / form --%>
<%
    System.out.println("path: " + path);
    if (null != path) {
%>
<iframe id="admFrame" src="<%=path%>" style="border:none;" name="admRsrcFrame"></iframe>
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
