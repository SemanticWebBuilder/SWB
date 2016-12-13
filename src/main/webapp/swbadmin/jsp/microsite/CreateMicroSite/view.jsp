<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();
    String lang = user.getLanguage();
    int nwp = 0;

    Iterator<WebPage> itso = wpage.listChilds(lang,true,false,false,true);
    if(itso.hasNext())
    {
        while(itso.hasNext())
        {
            WebPage so = itso.next();
            if(so instanceof WebPage && !(so instanceof MicroSite) )
            {
                nwp++;
                break;
            }
        }
    }

    SWBParamRequestImp imp=(SWBParamRequestImp)paramRequest;
    String mode=paramRequest.getArgument("mode","");

    String act = request.getParameter("act");

    SWBResourceURL urlAdd = null;

    int nivelWP = wpage.getLevel();
    if(nivelWP==1||nivelWP==2)
    {
        if(null==act)
        {
            urlAdd = paramRequest.getRenderUrl();
            urlAdd.setParameter("act", "view");
        }
        else
        {
            urlAdd = paramRequest.getRenderUrl();
            urlAdd.setParameter("act", "add");
        }
        urlAdd.setWindowState(SWBResourceURL.WinState_MAXIMIZED);
    }
    else if(nivelWP==3)
    {
        urlAdd = paramRequest.getRenderUrl();
        urlAdd.setParameter("act", "add");
        urlAdd.setWindowState(SWBResourceURL.WinState_MAXIMIZED);
    }

    
    //System.out.println("act:"+act);

    if(user.isRegistered()) //&&nwp==0&& imp.getRequest().getParameter("act")==null
    {
        if(mode!=null && mode.equals("menu") && act==null)
        {
            String urlAddElement=wpage.getUrl()+"?mode=showcombo";
            %>
                <div id="opcionesHeader" class="opt3">
                    <ul class="listaOpciones">
            <%
            if(nivelWP!=3 && urlAdd!=null)
            {
                %>
                    <li><a href="<%=urlAddElement%>">Agregar anuncio o entrada a directorio</a></li>
                <%
            }
            if(urlAdd!=null)
            {
                %>
                        <li><a href="<%=urlAdd%>">Agregar una comunidad</a></li>
                        
                <%
            }
            %>
                </ul>
                    </div>
            <%
            
        }
        else if(act!=null&&act.equals("view"))
        {
            if("Comunidades".equals(wpage.getId()))
            {
                wpage=wpage.getWebSite().getWebPage("Intereses");
            }

            StringBuffer select = new StringBuffer("");
            StringBuffer temas = new StringBuffer("");
            String opciones = null;
            if(!(wpage instanceof MicroSite))
            {
                if(wpage.getLevel()==1)
                {
                    //obteniendo WebPages de temas que sería el Level = 2
                    Iterator<WebPage> iteWP = wpage.listChilds(paramRequest.getUser().getLanguage(),true,false,false,true);
                    while(iteWP.hasNext())
                    {
                        WebPage wpc = iteWP.next();
                        if(!(wpc instanceof MicroSite))
                        {
                            opciones =  getSubTemas(wpc,lang);
                            if(opciones.trim().length()>0)
                            {
                                temas.append("<optgroup label=\""+wpc.getDisplayName()+"\">");
                                temas.append(opciones);
                                temas.append("</optgroup>");
                            }
                        }
                    }
                    if(null!=temas&&temas.toString().trim().length()>0)
                    {
                        select.append("<select name=\"wpid\">");
                        select.append(temas);
                        select.append("</select>");
                    }

                } else if(wpage.getLevel()==2)
                {
                    opciones = getSubTemas(wpage,lang);
                    if(null!=opciones&&opciones.trim().length()>0)
                    {
                        select.append("<select name=\"wpid\">");
                        select.append(opciones);
                        select.append("</select>");
                    }
                }
                
                if(select.toString().trim().length()==0&&wpage.getLevel()==1)
                {
                    if(!(wpage instanceof MicroSite))
                    {
                        opciones =  getSubTemas(wpage,lang);
                    }
                    if(null!=opciones&&opciones.trim().length()>0)
                    {
                        select.append("<select name=\"wpid\">");
                        select.append(opciones);
                        select.append("</select>");
                    }
                }
            }


        %>
        <div class="opt3" id="opcionesHeader">
            <div class="comboOpciones">
                <p>Seleccione la categoria para crear el elemento:</p>
                <form method="post" action="<%=urlAdd%>" id="faddMS">
                    <p class="comboSelect">
                       <%=select.toString()%>
                    </p>
                    <p class="comboBtns">
                        <button type="submit" name="btnsubmit">Agregar</button>
                        <button onclick="javascript:Cancel('<%=paramRequest.getRenderUrl()%>');" type="button" name="btnsubmit">Cancelar</button>
                    </p>
                </form>
            </div>
        </div>
                    <script type="text/javascript">
                    function Cancel(url)
                    {
                        window.location=url;
                    }
                    </script>
        <%-- <div id="opcionesHeader" class="opt3">
            
            <ul class="listaOpciones">
                <li>Seleccione la categoria para crear la comunidad:
                    <form id="faddMS" action="<%=urlAdd%>" method="post">
                <%=select.toString()%>
                <button name="btnsubmit" type="submit">Agregar</button><button name="btnsubmit" type="button" onClick="javascript:Cancel('<%=paramRequest.getRenderUrl()%>');">Cancelar</button>
                </form></li>
            </ul>               
        </div>
                 <script type="text/javascript">
                    function Cancel(url)
                    {
                        window.location=url;
                    }
                    </script>
        --%>
<%
        }
     }
%>

<%!
    public String getSubTemas(WebPage wp, String lang)
    {
        StringBuffer stOpts = new StringBuffer("");
        // obteniendo el listado de subtemas
        Iterator<WebPage> itwpst = wp.listChilds(lang,true,false,false,true);
        while(itwpst.hasNext())
        {
            WebPage wpst = itwpst.next();
            if(!(wpst instanceof MicroSite))
            {
               stOpts.append("<option label=\""+wpst.getDisplayName()+"\">"+wpst.getId()+"</option>");
            }
        }
        return stOpts.toString();
    }
%>