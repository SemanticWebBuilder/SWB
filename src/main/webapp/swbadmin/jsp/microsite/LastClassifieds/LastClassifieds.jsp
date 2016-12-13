<%@page import="java.sql.*,java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<h2>Clasificados m&aacute;s recientes</h2>
<ul class="listaElementos">
    <%
            String defaultFormat = "dd/MM/yy HH:mm";
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            //WebPage webpage = (WebPage) request.getAttribute("webpage");
            WebPage webpage = paramRequest.getWebPage();

            //WebPage clasificados = webpage.getWebSite().getWebPage("Clasificados");
            ArrayList<Clasified> elements = new ArrayList<Clasified>();
            User user = paramRequest.getUser();

            int limit = 10;
            Connection con = null;
            try
            {
                con = SWBUtils.DB.getDefaultConnection();
                java.util.Calendar today = java.util.Calendar.getInstance();
                today.setTime(new java.util.Date(System.currentTimeMillis()));
                java.util.Calendar dayago14 = java.util.Calendar.getInstance();
                dayago14.add(java.util.Calendar.DAY_OF_MONTH, -14);
                dayago14.set(java.util.Calendar.HOUR, 0);
                dayago14.set(java.util.Calendar.MINUTE, 0);
                dayago14.set(java.util.Calendar.SECOND, 0);

                PreparedStatement pt = con.prepareStatement("SELECT log_objuri FROM swb_admlog where log_action='create' and log_modelid=? and log_date BETWEEN ? AND ? order by log_date desc");
                pt.setString(1, webpage.getWebSiteId());
                pt.setTimestamp(3, new java.sql.Timestamp(today.getTime().getTime()));
                pt.setTimestamp(2, new java.sql.Timestamp(dayago14.getTime().getTime()));
                ResultSet rs = pt.executeQuery();
                int i = 0;
                while (rs.next())
                {
                    String uri = rs.getString("log_objuri");
                    SemanticObject obj = SemanticObject.createSemanticObject(uri);
                    if (obj != null && obj.getSemanticClass() != null && (obj.getSemanticClass().equals(Clasified.sclass) || obj.getSemanticClass().isSubClass(Clasified.sclass)))
                    {
                        Clasified element = (Clasified) obj.createGenericInstance();
                        elements.add(element);
                        i++;
                        if (i == limit)
                        {
                            break;
                        }
                    }
                }
    %>
    <%
                rs.close();
                pt.close();
            }
            catch (SQLException e)
            {
                SWBUtils.getLogger(this.getClass()).error(e);

            }
            finally
            {
                if (con != null)
                {
                    try
                    {
                        con.close();
                    }
                    catch (Exception e)
                    {
                        SWBUtils.getLogger(this.getClass()).error(e);
                    }
                }
            }

            if (elements.size() == 0)
            {
                    %>
    <li>No hay actividad durante las últimas dos semanas</li>
    <%      
            }
            

            int count = 0;
            for (Clasified obj : elements)
            {

                String created = "Sin fecha";

                if (obj != null && obj.getCreated() != null)
                {
                    //created = iso8601dateFormat.format(obj.getCreated());
                    created = SWBUtils.TEXT.getTimeAgo(obj.getCreated(), "es");
                }
                String name = "Usuario desconocido";
                if (obj.getCreator() != null)
                {
                    name = obj.getCreator().getFullName();
                }
                if (obj != null && obj.getWebPage() != null && obj.getWebPage().getUrl() != null)
                {
                    String url = obj.getWebPage().getUrl();
                    String title = "Sin título";
                    if (obj.getTitle() != null)
                    {
                        title = obj.getTitle();
                    }
    %>
    <li><%=name%> agregó el anuncio <a href="<%=url%>"><%=title%></a>
        , <%=created%></li>
        <%
                    count++;
                    if (count == 10)
                    {
                        break;
                    }
                }

            }
            if (count == 0 && elements.size() != 0)
            {
        %>
    <li>No hay actividad durante las últimas dos semanas</li>
    <%            }

    %>
</ul>
