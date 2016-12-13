<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*,org.semanticwb.portal.api.*"%><%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String id=request.getParameter("suri");
    Object obj1=SWBPlatform.getSemanticMgr().getOntology().getGenericObject(id);
    if(obj1 instanceof Resource)
    {
        Resource obj=(Resource)obj1;
        SWBResource sem=SWBPortal.getResourceMgr().getResource(obj);
        //System.out.println("suri:"+obj.getSemanticObject().getEncodedURI());
        if(sem instanceof GenericSemResource)
        {
            SWBParamRequestImp req=new SWBParamRequestImp(request, obj, SWBContext.getAdminWebSite().getWebPage("bh_AdminPorltet"), user);
            req.setMode(SWBParamRequest.Mode_ADMIN);
            req.setWindowState(SWBParamRequest.WinState_MAXIMIZED);
            req.setVirtualTopic(obj.getWebSite().getHomePage());
            
            SWBHttpServletResponseWrapper resp=new SWBHttpServletResponseWrapper(response);
            
            sem.render(request, resp, req);
            
            out.print(resp.toString());
            
            //String url=SWBPlatform.getContextPath()+"/swb/SWBAdmin/bh_AdminPorltet/_vtp/"+obj.getWebSiteId()+"/"+obj.getWebSite().getHomePage().getId()+"/_rid/"+obj.getId()+"/_mod/admin/_wst/maximized";
            //System.out.println("url"+url);
            //<div dojoType="dijit.layout.ContentPane" href="< %=url% >" style="overflow: initial" style_="border:0px; width:100%; height:100%"></div>

        }else
        {
            String url=SWBPlatform.getContextPath()+"/swb/SWBAdmin/ExternalAdmin/_vtp/"+obj.getWebSiteId()+"/"+obj.getWebSite().getHomePage().getId()+"/_rid/"+obj.getId()+"/_mod/admin/_wst/maximized";
%><iframe dojoType_="dijit.layout.ContentPane" src="<%=url%>" style="border:0px; width:100%; height:100%" frameborder="0" scrolling="yes"></iframe>
<%
        }
    }
%>