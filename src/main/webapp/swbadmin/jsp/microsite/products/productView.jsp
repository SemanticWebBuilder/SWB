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
    System.out.println("member:"+member);
%>
<table border="0" width="100%">
<%
    Iterator<ProductElement> it=ProductElement.ClassMgr.listProductElementByWebPage(wpage,wpage.getWebSite());
    int i=0;
    while(it.hasNext())
    {
        ProductElement product=it.next();
        SWBResourceURL viewurl=paramRequest.getRenderUrl().setParameter("act","detail").setParameter("uri",product.getURI());
        if(product.canView(member))
        {
            if(i%2==0)out.println("<tr>");
            String basepath = SWBPortal.getWebWorkPath() + "/models/" + website.getId() + "/Resource/" + base.getId() + "/products/" + product.getId() + "/";
%>
    <td width="50%" valign="top">
      <table border="0" width="100%" cellspacing="10">
        <tr><td valign="top" width="130">
        <a href="<%=viewurl%>">
            <img src="<%=basepath+product.getSmallPhoto()%>" width="125" border="0">
        </a>
        </td><td valign="top" align="left"><small>
        <b><%=product.getTitle()%></b> <br/>
        <%=product.getProdDescription()%> <br/>
        <%=product.getCreated()%> <br/>
        <!--</small></td><td valign="top"><small>-->
        <%=product.getViews()%> vistas<br/>
        </small></td></tr>
      </table>
    </td>
<%
            if(i%2==1)out.println("</tr>");
            i++;
        }
    }
    if(i%2==1)out.println("<td></td></tr>");
%>
</table>
<%
    if(member!=null && member.canAdd())
    {
%>
<center>
    <a href="<%=paramRequest.getRenderUrl().setParameter("act","add").toString()%>">Agregar Producto</a>
</center>
<%  }%>