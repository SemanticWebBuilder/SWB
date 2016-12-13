<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>

<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    String act=request.getParameter("act");
    //System.out.println("suri:"+suri);
    if(suri==null)
    {
        String code=SWBUtils.IO.readInputStream(request.getInputStream());
        System.out.println(code);
        String uri=SWBContext.getAdminWebSite().getHomePage().getEncodedURI();
%>
    Error params not found...
    <a href="?suri=<%=uri%>">edit</a>
<%
        return;
    }

    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(suri);

    if(obj!=null && act!=null && user!=null && user.getURI()!=null)
    {
        if(act.equals("active"))
        {
            UserFavorite fav=user.getUserFavorite();
            if(fav==null)
            {
                fav=user.getUserRepository().createUserFavorite();
                user.setUserFavorite(fav);
            }
            fav.addObject(obj);
            out.println(obj.getSemanticClass().getDisplayName(lang)+" fue agregado...");
            out.println("<script type=\"text/javascript\">");
            out.println("   addItemByURI(mfavoStore, null, '"+obj.getURI()+"');");
            out.println("   updateTreeNodeByURI('"+suri+"');");
            out.println("   reloadTab('"+suri+"');");
            out.println("</script>");
        }else
        {
            UserFavorite fav=user.getUserFavorite();
            if(fav!=null)
            {
                fav.removeObject(obj);
            }
            out.println(obj.getSemanticClass().getDisplayName(lang)+" fue eliminado...");
            out.println("<script type=\"text/javascript\">");
            out.println("   removeTreeNode(mfavoStore, getItem(mfavoStore,'"+suri+"'),false);");
            //out.println("   updateTreeNodeByURI('"+suri+"');");
            out.println("   reloadTab('"+suri+"');");
            out.println("</script>");

        }
    }
%>
<!-- a href="#" onclick="submitUrl('/swb/swb',this); return false;">click</a -->