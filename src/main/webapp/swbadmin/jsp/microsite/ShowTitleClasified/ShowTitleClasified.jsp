<%@page import="org.semanticwb.platform.SemanticObject"%><%@page contentType="text/html"%><%@page import="org.semanticwb.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%><%
            String url = request.getParameter("uri");
            if (url != null && !url.trim().equals(""))
            {
                try
                {
                    SemanticObject so = SemanticObject.createSemanticObject(request.getParameter("uri"));
                    if (so != null)
                    {
                        GenericObject go = so.createGenericInstance();
                        if (go instanceof Descriptiveable)
                        {
                            Descriptiveable desc = (Descriptiveable) go;
%>
- <%=desc.getTitle()%>
<%
                        }
                    }
                }
                catch (Throwable e)
                {
                    e.printStackTrace();
                }
            }
%>