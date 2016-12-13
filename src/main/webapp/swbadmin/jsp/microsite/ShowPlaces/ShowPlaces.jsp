<%@page import="java.io.*,java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<div class="tabsTemas">
<ul>
<%
    User user=(User)request.getAttribute("user");
    String lang="es";
    if(user.getLanguage()!=null)
    {
        lang=user.getLanguage();
    }
    WebPage webpage = (WebPage) request.getAttribute("webpage");
    WebPage sitios_de_Interes = webpage.getWebSite().getWebPage("Sitios_de_Interes");
    Iterator<WebPage> pages=sitios_de_Interes.listVisibleChilds(lang); // ordenados por nombre
    int count=0;
    while(pages.hasNext())
    {
        WebPage child=pages.next();
        String path="/models/"+ webpage.getWebSiteId() +"/css/iconos/"+child.getId()+".png";     
        path="/work"+path;                
        /*try
        {
            InputStream in=SWBPortal.getFileFromWorkPath(path);
            if(in==null)
            {
                path="/work/models/"+ webpage.getWebSiteId() +"/css/iconos/default.png";;                
            }
            else
            {
                path="/work"+path;                
            }

        }
        catch(Exception e)
        {
            path="/work/models/"+ webpage.getWebSiteId() +"/css/iconos/default.png";;            
        }*/
        %>
            <li><img width="60" height="60" src="<%=path%>" alt="<%=child.getTitle()%>"><a href="<%=child.getUrl()%>"><%=child.getTitle()%></a></li>
        <%
        count++;
        if(count==8)
        {
            break;
        }

    }

%>
    </ul>
    <div class="clear">&nbsp;</div>
</div>
<div class="ademas">
    <div class="ademasHeader">
        <%
            if(pages.hasNext())
            {
                %>
                <p>Además...</p>
                <%
            }
        %>
        
        <a href="<%=sitios_de_Interes.getUrl()%>">ver listado completo</a></div>
        <ul class="ademasContent">
        <%
            count=0;
            while(pages.hasNext())
            {
                WebPage child=pages.next();
                %>
                    <li><a href="<%=child.getUrl()%>"><%=child.getTitle()%></a></li>
                <%
                count++;
                if(count==15)
                {
                    break;
                }
            }
        %>        
    </ul>
    <div class="clear">&nbsp;</div>
</div>
