<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    SWBResourceURL action=paramRequest.getActionUrl();    
    SWBResourceURL cancel=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN);
    boolean simplemode=false;
    String value=paramRequest.getResourceBase().getAttribute("simplemode","false");
    simplemode=Boolean.parseBoolean(value);
    String nummax=paramRequest.getResourceBase().getAttribute("numax","-1");
    String categoryUri=paramRequest.getResourceBase().getAttribute("category","");
    int inummax=-1;
    if(nummax!=null && !nummax.trim().equals(""))
    {
        try
        {
            inummax=Integer.parseInt(nummax);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }

%>
<script type="text/javascript">
    <!--
        function cancelar()
        {
           window.location='<%=cancel%>';
        }
    -->

</script>

<form method="post" action="<%=action%>">
    <input type="hidden" name="act" value="config"/>
    <table width="100%" cellpadding="2" cellspacing="2">
        <tr>
            <td>
                Categoria despluegar:
            </td>
            <td>
                <select name="category">
                    <%
                        if(categoryUri==null || categoryUri.equals(""))
                        {
                            %>
                            <option selected value="all">Todas</option>
                            <%
                        }
                        else
                        {
                            %>
                            <option value="all">Todas</option>
                            <%
                        }
                    %>
                    
                    <%
                        Iterator<Category> categories=Category.ClassMgr.listCategories(paramRequest.getWebPage().getWebSite());
                        while(categories.hasNext())
                        {
                            Category category=categories.next();
                            String selected="";

                            if(category.getURI().equals(categoryUri))
                            {
                                selected="selected";
                            }
                            %>
                            <option <%=selected%> value="<%=category.getURI()%>"><%=category.getTitle()%></option>
                            <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                Número máximos de noticias a despluegar:
            </td>
            <td>
                <select name="numax">
                    <%
                        if(inummax<1)
                        {
                            %>
                            <option selected value="all">Todas</option>
                            <%
                        }
                        else
                        {
                            %>
                            <option value="all">Todas</option>
                            <%
                        }
                    %>
                    
                    <%
                        for(int i=1;i<=50;i++)
                        {
                            String selected="";
                            if(i==inummax)
                            {
                                selected="selected";
                            }
                            %>
                            <option <%=selected%> value="<%=i%>"><%=i%></option>
                            <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                Modo simple:
            </td>
            <td>
                <%
                    if(simplemode)
                        {
                        %>
                            <input checked type="radio" name="modo" value="simplemode">Sí&nbsp;&nbsp;&nbsp;
                            <input type="radio" name="modo" value="content">No
                        <%
                        }
                        else
                        {
                            %>
                            <input type="radio" name="modo" value="simplemode">Sí&nbsp;&nbsp;&nbsp;
                            <input checked type="radio" name="modo" value="content">No
                            <%
                        }
                %>
                
                
            </td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" value="Guardar"><input type="button" value="Cancelar" onClick="javascript:cancelar()"></td>
        </tr>
    </table>
</form>