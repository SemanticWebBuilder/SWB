<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    int columnas=1;
    try
    {
        columnas=Integer.parseInt(paramRequest.getResourceBase().getAttribute("columns", "1"));
    }
    catch(Exception e)
    {

    }
    if(columnas<=0)
    {
        columnas=1;
    }
    String classAtt="recentEntry_last";
    if(paramRequest.getCallMethod()==paramRequest.Call_CONTENT)
    {
        classAtt="panorama";
    }
    %>
    <div class="<%=classAtt%>">
    <h2 class="titulo">Noticias recientes</h2>
    <%
    String pathIamge = SWBPortal.getWebWorkPath();
    ArrayList<NewsElement> elements=(ArrayList<NewsElement>)request.getAttribute("elements");
    if(elements.size()>0)
    {

            String defaultFormat = "dd/MM/yyyy HH:mm";
            SimpleDateFormat iso8601dateFormat = new SimpleDateFormat(defaultFormat);
            int renglones=elements.size() / columnas;
            if((elements.size() % columnas) !=0 )
            {
                renglones++;
            }
             %>
            <table width="100%" border="0">
            <%
            NewsElement[] elementsArray=elements.toArray(new NewsElement[elements.size()]);
            for(int iRenglon=0;iRenglon<renglones;iRenglon++)
            {
                %>
                <tr>
                <%
                for(int col=0;col<columnas;col++)
                {
                    int iElement=(iRenglon*columnas)+col;
                    if(iElement<elementsArray.length)
                    {
                        NewsElement element=elementsArray[iElement];
                        User user = paramRequest.getUser();
                        boolean canview=false;
                        if(element.getWebPage()!=null && user!=null)
                        {
                            Member member=Member.getMember(user, element.getWebPage());
                            if(member!=null)
                            {
                                canview=element.canView(member);                                
                            }                            
                        }
                        String created="Sin fecha";
                        if(element.getCreated()!=null)
                        {
                            created=iso8601dateFormat.format(element.getCreated());
                        }
                        String href=element.getURL();
                        String src=pathIamge+element.getNewsImage();
                        if(element.getNewsImage()!=null)
                        {
                            src=pathIamge+element.getNewsImage();
                        }
                        String title=element.getTitle();
                        if(title==null)
                        {
                            title="";
                        }
                        String description=element.getDescription();
                        if(description==null)
                        {
                            description="Sin descripción";
                        }
                        if(description.length()>200)
                        {
                            description=description.substring(0, 197)+" ...";
                        }
                        %>
                        <td valign="top">
                              <div class="entry">
                              <%
                                if(src!=null)
                                {
                                    %>
                                    <p><img src="<%=src%>" alt="<%=title%>" width="49" height="49" /></p>
                                    <%
                                }
                              %>
                              <h3 class="titulo">
                                  <%
                                  if(canview)
                                  {
                                      %>
                                      <a href="<%=href%>"><%=title%></a>
                                      <%
                                  }
                                  else
                                  {
                                        %>
                                        <%=title%> (No se tiene acceso)
                                        <%
                                  }
                                  %>
                                  </h3>
                              <p class="titulo"><%=created%></p>
                              <p><%=description%></p>
                              </div>
                        </td>
                        <%
                    }
                    else
                    {
                        %>
                        <td>&nbsp;</td>
                        <%
                    }
                }
                %>
                </tr>
            <%
            }
             %>
            </table>
            <%
            
           
            if(paramRequest.getWebPage().getWebSite().getWebPage("Ultimas_Noticias")!=null && paramRequest.getCallMethod()!=paramRequest.Call_CONTENT)
            {
                String path=paramRequest.getWebPage().getWebSite().getWebPage("Ultimas_Noticias").getUrl();
                %>
                <p class="vermas"><a href="<%=path%>" >Ver m&aacute;s</a></p>
                <%
            }
    }
    else
        {
        %>
        <p>No hay noticias publicadas</p>
        <%
        }
%>
    </div>