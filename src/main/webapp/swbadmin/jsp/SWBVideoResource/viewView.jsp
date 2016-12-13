<%@page contentType="text/html"%>
<%@page import="java.text.*,org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.video.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar el video: '+title+'?'))
        {            
            window.location.href=url;
        }
    }
</script>

<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>
<%
            java.text.SimpleDateFormat dateFormat;

            //out.println("uri:"+request.getParameter("suri"));
            String lang = "es";
            Locale locale = new Locale(lang);
            dateFormat = new java.text.SimpleDateFormat("dd-MMM-yyyy", locale);
            String[] months =
            {
                "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
            };
            java.text.DateFormatSymbols fs = dateFormat.getDateFormatSymbols();
            fs.setShortMonths(months);
            dateFormat.setDateFormatSymbols(fs);

            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");

            boolean callStrategy = false;
            if(paramRequest.getCallMethod()==SWBParamRequest.Call_STRATEGY)
                callStrategy=true;
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            String idwp = paramRequest.getResourceBase().getAttribute("idwp","");
            System.out.println("idwp:"+idwp);
            WebPage wpconfig = wpage.getWebSite().getWebPage(idwp);

            if(null==wpconfig) wpconfig = wpage;
            //String suscribeURL = paramRequest.getActionUrl().setParameter("act", "subscribe").toString();
            //String unsuscribeURL = paramRequest.getActionUrl().setParameter("act", "unsubscribe").toString();
            String urlAddVideo = paramRequest.getRenderUrl().setParameter("act", "add").toString();
            ArrayList<VideoElement> elements = new ArrayList();
            int elementos = 0;
            Iterator<VideoElement> it = VideoElement.ClassMgr.listVideoElementByWebPage(wpconfig);
            it = SWBComparator.sortByCreated(it, false);
            boolean hasFirstCode = false;
            String firstObjCode = "";
            while (it.hasNext())
            {
                VideoElement element = it.next();
                //if (element.canView(member))
                {
                    elements.add(element);
                    elementos++;
                }
                if(!hasFirstCode)
                {
                    hasFirstCode=true;
                    firstObjCode = element.getVideoCode().replaceAll("&", "&amp;").replace("'", "\\'");
                }


            }
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


%>

    <!-- paginacion -->
    <%

            if (paginas > 1&&!callStrategy)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
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
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->

    <%
            if (elements.size() == 0)
            {
    %>
    <p>No hay videos registrados en la comunidad</p>
    <%            }
            int iElement = 0;
            if(callStrategy)
              {
                if(hasFirstCode)
                {
    %>
        <script type="text/javascript">
                    <!--
                    document.write('<%=firstObjCode%>');
                    -->
        </script>
    <%
                }
    %>
    <div id="listadoVideos">
        <ul>
    <%
            }
            for (VideoElement video : elements)
            {
                SWBResourceURLImp urlDetail = (SWBResourceURLImp)paramRequest.getRenderUrl();
                urlDetail.setParameter("act", "detail");
                urlDetail.setParameter("uri", video.getURI());
                urlDetail.setTopic(wpconfig);
                urlDetail.setMode(SWBResourceURL.Mode_VIEW);
                //SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", video.getURI());

                //if (video.canView(member))
                {
                    iElement++;
                    if (iElement > fin || (iElement==4 && paramRequest.getCallMethod()==SWBParamRequest.Call_STRATEGY))
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        //String rank = df.format(video.getRank());
                        
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", video.getEncodedURI());
                        
                        String title = "Sin título";
                        if (video.getTitle() != null)
                        {
                            title = video.getTitle().replace("'", "\\'");
                        }
                        String description = "Sin descripción";
                        if (video.getDescription() != null)
                        {
                            description = video.getDescription().replace("'", "\\'");
                            if(callStrategy&&description.length()>100) description=description.substring(0, 99)+"...";
                        }
                        String postAuthor = "Usuario dado de baja";
                        if (video.getCreator() != null)
                        {
                            postAuthor = video.getCreator().getFirstName();
                        }

                        if(callStrategy)
                            {
%>
            <li><a rel="destino" href="<%=urlDetail.toString(true)%>"><%=description%>...&quot;</a></li>
<%
                            }
                        else
                            {

%>
    <div class="bloqueVideos">
        <img src="<%=video.getPreview()%>" alt="<%=title%>"/>
        <div class="listadoVideos">
            <h2>
                <script type="text/javascript">
                    <!--
                    document.write('<%=title%>');
                    -->
                </script></h2>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(video.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(video.getCreated(), user.getLanguage())%></p>
            <p>
                <script type="text/javascript">
                    <!--
                    document.write('<%=description%>');
                    -->
                </script>
                    | <a href="<%=urlDetail.toString(true)%>">Ver M&aacute;s</a>
                
            </p>
            <!--
            <p class="stats">
            	Puntuación: <%//=rank%><br/>
                <%//=video.getViews()%> vistas
            </p> -->
        </div>
    </div>
    <%
                        }
                    }
                }
            }
         if(callStrategy)
         {
    %>
            </ul>
          <p class="listaVideos"><a href="<%=wpconfig.getUrl()%>" rel="gb_page_center[1017, 610]">sección completa de videos</a></p>
    </div>
<%
        }

%>

    <!-- paginacion -->
    <%
            if (paginas > 1&&!callStrategy)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
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
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->


    <% //<div class="columnaCentro">
            if (paginas > 1&&!callStrategy)
            {
    %>
    <br/><br/>
    <%            }
            //</div>

    %>
    
   

