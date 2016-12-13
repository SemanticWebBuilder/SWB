<%@page contentType="text/html"%>
<%@page import="java.net.*,org.semanticwb.opensocial.model.*,org.semanticwb.opensocial.resources.*,java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script>
    function loadImage(imagen)
    {
        <%
            String path=SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
        %>
        imagen.src='<%=path%>';
        
    }
</script>
<%!    private static final int ELEMENETS_BY_PAGE = 9;
%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    WebSite site=paramRequest.getWebPage().getWebSite();
    User user=paramRequest.getUser();
    SocialUser socialuser=SocialContainer.getSocialUser(user, session,site);
    SWBResourceURL proxy=paramRequest.getRenderUrl();
    proxy.setMode(SocialContainer.Mode_PROXY);
    proxy.setCallMethod(SWBResourceURL.Call_DIRECT);

    SWBResourceURL listurl=paramRequest.getRenderUrl();
    listurl.setMode(SocialContainer.Mode_LISTGADGETS);
    listurl.setCallMethod(SWBResourceURL.Call_DIRECT);
    String categorysearch=request.getParameter("categorysearch");
    ArrayList<Gadget> _allgadgets=new ArrayList<Gadget>();
    if(categorysearch!=null && !"".equals(categorysearch))
    {
        Gadget[] gadgets=Gadget.getGadgetsByCategory(categorysearch, site);
        _allgadgets.addAll(Arrays.asList(gadgets));
    }
    else
    {
        Iterator<Gadget> gadgets=Gadget.ClassMgr.listGadgets(site);
        while(gadgets.hasNext())
        {
            Gadget gadget=gadgets.next();
            if(socialuser.canAdd(gadget))
            {
                _allgadgets.add(gadget);
            }
        }
    }
    
    String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
    int elementos = _allgadgets.size();
    int paginas = elementos / ELEMENETS_BY_PAGE;
    if (elementos % ELEMENETS_BY_PAGE != 0)
    {
        paginas++;
    }
    int inicio = 0;
    int fin = ELEMENETS_BY_PAGE;
    int ipage = 1;
    if (request.getParameter("ipage") != null)
    {
        try
        {
            ipage = Integer.parseInt(request.getParameter("ipage"));
            inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
            fin = (ipage * ELEMENETS_BY_PAGE);
        }
        catch (NumberFormatException nfe)
        {
            ipage = 1;
        }
    }
    if (ipage < 1 || ipage > paginas)
    {
        ipage = 1;
    }
    if (inicio < 0)
    {
        inicio = 0;
    }
    if (fin < 0)
    {
        fin = ELEMENETS_BY_PAGE;
    }
    if (fin > elementos)
    {
        fin = elementos;
    }
    if (inicio > fin)
    {
        inicio = 0;
        fin = ELEMENETS_BY_PAGE;
    }
    if (fin - inicio > ELEMENETS_BY_PAGE)
    {
        inicio = 0;
        fin = ELEMENETS_BY_PAGE;
    }
    inicio++;
    if (paginas > 1)
    {
        %>
        <div class="paginacion">
            <%
                
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = listurl + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = listurl + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img border="0" src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
                &nbsp;&nbsp;&nbsp;<a href="<%=listurl%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %>
            <strong>
                <%                    }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                    }
                               %></a>&nbsp;&nbsp;&nbsp;
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img border="0" src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div><br>
    
        <%
    }
    ArrayList<Gadget> _gadgets=new ArrayList<Gadget>();
    int iElement = 0;
    for (Gadget gadget : _allgadgets)
    {
        iElement++;
        if (iElement > fin)
        {
            break;
        }
        if (iElement >= inicio && iElement <= fin)
        {
            _gadgets.add(gadget);
        }
    }


%>


<table width="100%" cellpadding="2" cellspacing="2">
    <tr>
        <td colspan="2">
            <table width="100%" cellpadding="2" cellspacing="2">
                <tr>
                    <td valign="top">
                        <p>Buscar:</p>
                    </td>
                    <td valign="top">
                        <form action="<%=listurl%>">
                            <input type="text" name="search" value="" maxlength="20" size="30">
                        </form>
                    </td>
                </tr>
            </table>
            
        </td>
    </tr>
    <tr>
        <td valign="top"><h2>Categorias</h2><br><a href="<%=listurl%>">Todas</a><br><br>
            <%
                String[] categories=Gadget.getAllCategories(site);
                for(String category : categories)
                {
                    %>
                    <a href="<%=listurl%>?categorysearch=<%=category%>"><%=category%></a><br><br>
                    <%
                }
            %>

        </td>
        <td>
            <%
    if(!_gadgets.isEmpty())
    {
        %>
        <table width="100%" cellpadding="2" cellspacing="2">
        <%
        int rows=_gadgets.size()/3;
        if(_gadgets.size()%3!=0)
        {
            rows++;
        }
        for(int i=0;i<rows;i++)
        {
            Gadget g1=null;
            Gadget g2=null;
            Gadget g3=null;
            int index=i*3;
            if(_gadgets.size()>index)
            {
                g1=_gadgets.get(index);
            }
            index++;
            if(_gadgets.size()>index)
            {
                g2=_gadgets.get(index);
            }
            index++;
            if(_gadgets.size()>index)
            {
                g3=_gadgets.get(index);
            }

            %>
            <tr>
            <%
            if(g1!=null)
            {

                String title=g1.getDirectoryTitle(socialuser);
                if(title==null)
                {
                    title=g1.getTitle(socialuser);
                }
                String img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                if(g1.getThumbnail()!=null)
                {
                    img=g1.getThumbnail().toString();
                    try
                    {
                        URL url=new URL(img);
                        img=proxy.toString()+"?url="+URLEncoder.encode(img);                        
                     
                    }
                    catch(Exception e)
                    {
                        img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                    }
                }
                SWBResourceURL edit=paramRequest.getRenderUrl();
                edit.setMode(SocialContainer.Mode_CONFIGGADGET);
                edit.setCallMethod(SWBResourceURL.Call_DIRECT);
                edit.setParameter("url", g1.getUrl());
                %>
                <td><img onError="loadImage(this);" border="0" alt="<%=title%>"  width="120" height="60" src="<%=img%>"><a href="<%=edit%>"><br><%=title%></a></td>
                <%
            }
            else
            {
                %>
                <td>&nbsp;</td>
                <%
            }

            if(g2!=null)
            {
                String title=g2.getDirectoryTitle(socialuser);
                if(title==null)
                {
                    title=g2.getTitle(socialuser);
                }
                String img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                if(g2.getThumbnail()!=null)
                {
                    img=g2.getThumbnail().toString();
                    try
                    {
                        URL url=new URL(img);
                        img=proxy.toString()+"?url="+URLEncoder.encode(img);                        
                    }
                    catch(Exception e)
                    {
                        img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                    }
                }
                SWBResourceURL edit=paramRequest.getRenderUrl();
                edit.setMode(SocialContainer.Mode_CONFIGGADGET);
                edit.setCallMethod(SWBResourceURL.Call_CONTENT);



                edit.setParameter("url", g2.getUrl());
                %>
                <td><img  onError="loadImage(this);" border="0" alt="<%=title%>"  width="120" height="60" src="<%=img%>"><a href="<%=edit%>"><br><%=title%></a></td>
                <%
            }
            else
            {
                %>
                <td>&nbsp;</td>
                <%
            }
            if(g3!=null)
            {
                String title=g3.getDirectoryTitle(socialuser);
                if(title==null)
                {
                    title=g3.getTitle(socialuser);
                }
                String img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                if(g3.getThumbnail()!=null)
                {
                    img=g3.getThumbnail().toString();
                    try
                    {
                        URL url=new URL(img);
                        img=proxy.toString()+"?url="+URLEncoder.encode(img);
                    }
                    catch(Exception e)
                    {
                        img = SWBPortal.getContextPath() + "/swbadmin/jsp/opensocial/sinfoto.png";
                    }
                }
                SWBResourceURL edit=paramRequest.getRenderUrl();
                edit.setMode(SocialContainer.Mode_CONFIGGADGET);
                edit.setCallMethod(SWBResourceURL.Call_CONTENT);
                edit.setParameter("url", g3.getUrl());
                %>
                <td><img onError="loadImage(this);" alt="<%=title%>"  width="120" height="60" src="<%=img%>"><a href="<%=edit%>"><br><%=title%></a></td>
                <%
             }
            else
            {
                %>
                <td>&nbsp;</td>
                <%
            }

            %>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <%
        }
        %>
        </table>
        <%
    }
%>
        </td>
    </tr>
</table>



            