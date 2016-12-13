<%@page import="java.util.*" %>
<%@page import="org.semanticwb.model.*" %>
<%@page import="org.semanticwb.portal.community.*" %>
<%-- 
    Document   : testMicrosite
    Created on : 19/11/2009, 03:07:52 PM
    Author     : javier.solis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%
    String name="Ciudad_Digital";
    boolean clear=false;
    if("true".equals(request.getParameter("clear")))clear=true;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>DirecroyObjects</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);
            Iterator<DirectoryObject> it=DirectoryObject.ClassMgr.listDirectoryObjects(site);
            while(it.hasNext())
            {
                DirectoryObject obj=it.next();
                if(clear && obj!=null)obj.remove();
                if(obj!=null)
                out.println(obj+"<br/>");
            }
        }
%>
        <h1>MicroSites</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);
            Iterator<MicroSite> it=MicroSite.ClassMgr.listMicroSites(site);
            while(it.hasNext())
            {
                MicroSite obj=it.next();
                if(clear && obj!=null)
                    {obj.remove();
                     }
                if(obj!=null)
                out.println(obj+"<br/>");
            }
        }

%>
        <h1>MicroSiteElements</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);
            Iterator<MicroSiteElement> it=MicroSiteElement.ClassMgr.listMicroSiteElements(site);
            while(it.hasNext())
            {
                MicroSiteElement obj=it.next();
                if(clear && obj!=null)obj.remove();
                if(obj!=null)
                out.println(obj+"<br/>");
            }
        }

%>
        <h1>Users</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);
            UserRepository urep=site.getUserRepository();
            Iterator<User> it=User.ClassMgr.listUsers(urep);
            while(it.hasNext())
            {
                User obj=it.next();
                if(clear && obj!=null)obj.remove();
                if(obj!=null)
                out.println(obj+":"+obj.getFullName()+"<br/>");
            }
        }

%>


 <h1>Post Elements</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);

            Iterator<PostElement> it=PostElement.ClassMgr.listPostElements(site);
            while(it.hasNext())
            {
                PostElement obj=it.next();
                if(clear && obj!=null)obj.remove();
                if(obj!=null)
                out.println(obj+":"+obj.getURI()+"<br/>");
            }
        }

%>


 <h1>Blogs</h1>
<%
        {
            WebSite site=SWBContext.getWebSite(name);

            Iterator<Blog> it=Blog.ClassMgr.listBlogs(site);
            while(it.hasNext())
            {
                Blog obj=it.next();
                if(clear && obj!=null)obj.remove();
                if(obj!=null)
                out.println(obj+":"+obj.getURI()+"<br/>");
            }
        }

%>
    </body>
</html>
