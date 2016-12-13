<%-- 
    Document   : showContents
    Created on : 14/05/2009, 11:10:17 AM
    Author     : victor.lorenzana
--%>

<%@page contentType="text/html" import="org.semanticwb.*,org.semanticwb.repository.*,org.semanticwb.repository.BaseNode,org.semanticwb.platform.*,org.semanticwb.repository.office.*,java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        String uri=request.getParameter("uri");
        out.println("<div>");
                 out.println("<table width='100%'>");
                 out.println("<tr>");
                 out.println("<th>");
                 out.println("Nombre");
                 out.println("</th>");
                 out.println("<th>");
                 out.println("Creado");
                 out.println("</th>");

                 out.println("<th>");
                 out.println("Tipo");
                 out.println("</th>");

                 out.println("<th>");
                 out.println("Título");
                 out.println("</th>");
                 out.println("<th>");
                 out.println("Descripción");
                 out.println("</th>");
                 out.println("</tr>");
        if(uri!=null && !uri.trim().equals(""))
        {
             SemanticObject object=SemanticObject.createSemanticObject(uri);
             if(object!=null && (object.getSemanticClass().isSubClass(Folder.sclass) || object.getSemanticClass().equals(Folder.sclass)))
             {            
                 Folder folder=new Folder(object);
                 Iterator<BaseNode> nodes=folder.listNodes();
                 
                 while(nodes.hasNext())
                 {
                     BaseNode child=nodes.next();
                     if(child.getSemanticObject().getSemanticClass().isSubClass(File.sclass) || child.getSemanticObject().getSemanticClass().equals(File.sclass))
                     {
                         File file=new File(child.getSemanticObject());
                         if(child.getSemanticObject().getSemanticClass().equals(OfficeContent.ClassMgr.sclass))
                         {
                             OfficeContent content=new OfficeContent(child.getSemanticObject());
                             out.println("<tr>");
                              out.println("<td>");
                             out.println(content.getName());
                             out.println("</td>");
                             if(content.getCreated()!=null)
                                 {
                             out.println("<td>");
                             out.println(content.getCreated());
                             out.println("</td>");
                             }
                             else
                                 {
                                 out.println("<td>");
                             out.println();
                             out.println("</td>");
                                 }

                             out.println("<td>");
                             out.println(content.getSemanticObject().getSemanticClass().getPrefix()+":"+content.getSemanticObject().getSemanticClass().getName());
                             out.println("</td>");

                             out.println("<td>");
                             out.println(content.getTitle());
                             out.println("</td>");
                             out.println("<td>");
                             out.println(content.getDescription());
                             out.println("</td>");

                             out.println("</tr>");
                         }
                         else
                         {
                             out.println("<tr>");
                             out.println("<td>");
                             out.println(file.getName());
                             out.println("</td>");

                             if(file.getCreated()!=null)
                                 {
                             out.println("<td>");
                             out.println(file.getCreated());
                             out.println("</td>");
                             }
                             else
                                 {
                                 out.println("<td>");
                             out.println();
                             out.println("</td>");
                                 }

                             out.println("<td>");
                             out.println(file.getSemanticObject().getSemanticClass().getPrefix()+":"+file.getSemanticObject().getSemanticClass().getName());
                             out.println("</td>");

                             out.println("<td>");
                             out.println("");
                             out.println("</td>");
                             out.println("<td>");
                             out.println("");
                             out.println("</td>");
                             out.println("</tr>");
                         }
                    }

                 }
                 
                 }
             
        }
                 out.println("</table>");
                 out.println("</div>");
        %>
    </body>
</html>
