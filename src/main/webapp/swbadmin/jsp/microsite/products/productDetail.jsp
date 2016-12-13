<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*,org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.community.PhotoElement,org.semanticwb.portal.SWBFormButton"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();
    WebSite website=wpage.getWebSite();
    Resource base=paramRequest.getResourceBase();
    Member member=Member.getMember(user,wpage);
%>
<%
        String uri=request.getParameter("uri");
        ProductElement rec=(ProductElement)SemanticObject.createSemanticObject(uri).createGenericInstance();
        rec.incViews();                             //Incrementar apariciones
        if(rec!=null)
        {
            SWBResourceURL viewurl=paramRequest.getRenderUrl().setParameter("act","detail").setParameter("uri",rec.getURI());
            String basepath = SWBPortal.getWebWorkPath() + "/models/" + website.getId() + "/Resource/" + base.getId() + "/products/" + rec.getId() + "/";
%>
      <table border="0" width="100%" cellspacing="10">
        <tr><td valign="top">
        <a href="<%=viewurl%>">
            <img src="<%=basepath+rec.getSmallPhoto()%>" width="125" border="0">
        </a>
        </td><td valign="top"><small>
        <%=rec.getTitle()%> <br/>
        <%=rec.getProdDescription()%> <br/>
        <%=rec.getCreated()%> <br/>
        <!--</small></td><td valign="top"><small>-->
        <%=rec.getViews()%> vistas<br/>
        </small></td></tr>
      </table>
<%
        }
%>

<center>
    <a href="<%=paramRequest.getRenderUrl()%>">Regresar</a>
    <%if(rec.canModify(member)){%><a href="<%=paramRequest.getRenderUrl().setParameter("act","edit").setParameter("uri",rec.getURI())%>">Editar Información</a><%}%>
    <%if(rec.canModify(member)){%><a href="<%=paramRequest.getActionUrl().setParameter("act","remove").setParameter("uri",rec.getURI())%>">Eliminar Producto</a><%}%>
</center>