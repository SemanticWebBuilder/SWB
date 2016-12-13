<%@page contentType="text/html"%>
<%@page import="java.text.SimpleDateFormat, org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            Resource base = paramRequest.getResourceBase();
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
%>

<%
            String uri = request.getParameter("uri");
            if (uri == null || uri.equals(""))
            {
                response.sendError(404);
                return;
            }
            EventElement rec = (EventElement) SemanticObject.createSemanticObject(uri).createGenericInstance();

            if (rec == null)
            {
                response.sendError(404);
                return;
            }
            if (!rec.canModify(member))
            {
                response.sendError(404);
                return;
            }
%>
<script type="text/javascript">
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.RadioButton");
    dojo.require("dijit.form.Button");
    dojo.require("dojo.parser");

    function validaForma()
    {
        var title = document.frmaeditevent.event_title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título del evento!');
            document.frmaeditevent.event_title.focus();
            return;
        }
        var description = document.frmaeditevent.event_description.value;
        if(!description)
        {
            alert('¡Debe ingresar la description del evento!');
            document.frmaeditevent.event_description.focus();
            return;
        }
        var event_audience = document.frmaeditevent.event_audience.value;
        if(!event_audience)
        {
            alert('¡Debe ingresar la audiencia a la que está dirigido el evento!');
            document.frmaeditevent.event_audience.focus();
            return;
        }
        var event_startDate = dijit.byId('event_startDate').getValue(false);
        if(!event_startDate)
        {
            alert('¡Debe ingresar la fecha de inicio del evento!');
            dijit.byId('event_startDate').focus();
            return;
        }
        var event_endDate = dijit.byId('event_endDate').getValue(false);
        if(!event_endDate)
        {
            alert('¡Debe ingresar la fecha de termino del evento!');
            dijit.byId('event_endDate').focus();
            return;
        }
        var event_startTime = dijit.byId('event_startTime').getValue(false);
        if(!event_startTime)
        {
            alert('¡Debe ingresar la hora de inicio del evento!');
            dijit.byId('event_startTime').focus();
            return;
        }
        var event_endTime = dijit.byId('event_endTime').getValue(false);
        if(!event_endTime)
        {
            alert('¡Debe ingresar la hora de termino del evento!');
            dijit.byId('event_endTime').focus();
            return;
        }
        var endDate=dijit.byId('event_endDate').getValue(false);
        endDate.setHours(0, 0, 0, 0);
        var startDate=dijit.byId('event_startDate').getValue(false);
        startDate.setHours(0, 0, 0, 0);
        difference = endDate.getTime() - startDate.getTime();        
        if(difference<0)
        {
            alert('¡La fecha de inicio debe ser menor a la fecha de termino del evento!');
            dijit.byId('event_startDate').focus();
            return;
        }
        if(difference==0)
        {

            var hendDate=dijit.byId('event_endTime').getValue(false);
            hendDate.setFullYear(2009, 1, 1)
            var hstartDate=dijit.byId('event_startTime').getValue(false);
            hstartDate.setFullYear(2009, 1, 1)
            difference = hendDate.getTime() - hstartDate.getTime();
            if(difference<0)
            {
                alert('¡La hora de inicio debe ser menor a la hora de termino del evento!');
                dijit.byId('event_startTime').focus();
                return;
            }

        }
        document.frmaeditevent.submit();
    }
    function changeStartDate()
    {
        var value=dijit.byId('event_startDate').getValue(false);
        if(value)
        {
            dijit.byId('event_endDate').constraints.min = value;
        }
        else
        {
            var max=new Date();
            max.setFullYear(max.getYear()+50,max.getMonth(),max.getDate());
            var min=new Date();
            dijit.byId('event_endDate').constraints.min = min;
            dijit.byId('event_endDate').constraints.max = max;
        }

    }
    function changeEndDate()
    {
        var value=dijit.byId('event_endDate').getValue(false);
        if(value)
        {
            dijit.byId('event_startDate').constraints.max = value;
        }
        else
        {
            var max=new Date();
            max.setFullYear(max.getYear()+50,max.getMonth(),max.getDate());
            var min=new Date();
            dijit.byId('event_startDate').constraints.max = max;
            dijit.byId('event_startDate').constraints.min = min;
        }
    }
</script>


<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
    <p><span class="tituloRojo">NOTA: </span>Se recomienda subir imagenes de 150 x 150.</p>
    <form name="frmaeditevent" id="frmaeditevent" class="swbform" enctype="multipart/form-data" method="post" action="<%=paramRequest.getActionUrl()%>">
        <div>
            <fieldset>
                <legend>Editar evento</legend>
                <div>
                    <p>
                        <label for="foto">Imagen del evento:&nbsp;</label>
                        <%
            String path = rec.getWorkPath();

            String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";

            if (rec.getEventThumbnail() != null)
            {
                int pos = rec.getEventThumbnail().lastIndexOf("/");
                if (pos != -1)
                {
                    String sphoto = rec.getEventThumbnail().substring(pos + 1);
                    rec.setEventThumbnail(sphoto);
                }
                pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + rec.getEventThumbnail();
            }

            String imgPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";
            if (rec.getEventImage() != null)
            {
                int pos = rec.getEventImage().lastIndexOf("/");
                if (pos != -1)
                {
                    String sphoto = rec.getEventImage().substring(pos + 1);
                    rec.setEventImage(sphoto);
                }
                imgPhoto = SWBPortal.getWebWorkPath() + path + "/" + rec.getEventImage();
            }
                        %>
                        <a href="<%= imgPhoto%>" target="_self">
                            <img id="img_<%=rec.getId()%>" src="<%= pathPhoto%>" alt="<%= rec.getTitle()%>" border="0" />
                        </a><br />
                        <input type="file" id="foto" name="foto" size="45" />
                    </p>
                    <p>
                        <label for="event_title">Título del evento:&nbsp;</label><br />
                        <input type="text" id="event_title" name="event_title" value="<%=(rec.getTitle() == null ? "" : rec.getTitle())%>" maxlength="50" size="45" />
                    </p>
                    <p>
                        <label for="event_description">Descripción del evento:&nbsp;</label><br />
                        <textarea id="event_description" name="event_description" cols="45" rows="5"><%=(rec.getDescription() == null ? "" : rec.getDescription())%></textarea>
                    </p>
                    <p>
                        <label for="event_audience">Dirigido a:&nbsp;</label><br />
                        <input type="text" id="event_audience" name="event_audience" value="<%=(rec.getAudienceType() == null ? "" : rec.getAudienceType())%>" maxlength="50" size="60" />
                    </p>
                    <p>
                        <label for="event_startDate">Fecha de inicio:&nbsp;</label><br />
                        <input dojoType="dijit.form.DateTextBox" type="text" id="event_startDate" name="event_startDate" value="<%=(rec.getStartDate() == null ? "" : dateFormat.format(rec.getStartDate()))%>" constraints="{datePattern:'dd/MM/yyyy'}" onchange="javascript:changeStartDate()"/>
                    </p>
                    <p>
                        <label for="event_endDate">Fecha de término:&nbsp;</label><br />
                        <input dojoType="dijit.form.DateTextBox" type="text" id="event_endDate" name="event_endDate" value="<%=(rec.getEndDate() == null ? "" : dateFormat.format(rec.getEndDate()))%>" constraints="{datePattern:'dd/MM/yyyy'}" onchange="javascript:changeEndDate()"/>
                    </p>
                    <p>
                        <label for="event_startTime">Hora de inicio:&nbsp;</label><br />
                        <input dojoType="dijit.form.TimeTextBox" type="text" id="event_startTime" name="event_startTime" value="<%=(rec.getStartTime() == null ? "" : "T" + timeFormat.format(rec.getStartTime()))%>" constraints="{timePattern:'hh:mm a', visibleRange:'T01:30:00'}" />
                    </p>
                    <p>
                        <label for="event_endTime">Hora de término:&nbsp;</label><br />
                        <input dojoType="dijit.form.TimeTextBox" type="text" id="event_endTime" name="event_endTime" value="<%=(rec.getEndTime() == null ? "" : "T" + timeFormat.format(rec.getEndTime()))%>" constraints="{timePattern:'hh:mm a', visibleRange:'T01:30:00'}" />
                    </p>
                    <p>
                        <label for="event_place">Lugar del evento:&nbsp;</label><br />
                        <input type="text" id="event_place" name="event_place" value="<%=(rec.getPlace() == null ? "" : rec.getPlace())%>" maxlength="120" size="60" />
                    </p>
                    <p>
                        <label for="event_tags">Etiquetas:&nbsp;</label><br />
                        <input type="text" id="event_tags" name="event_tags" value="<%=(rec.getTags() == null ? "" : rec.getTags())%>" maxlength="50" size="60" />
                    </p>
                </div>
            </fieldset>
            <fieldset>
                <legend>¿Quién puede ver este evento?</legend>
                <%String chk = "checked=\"checked\"";%>
                <div>
                    <p>
                        <label for="level"><input type="radio" name="level" value="0" <%if (rec.getVisibility() == 0)
            {
                out.println(chk);
            }%> />&nbsp;Cualquiera</label>
                    </p>
                    <p>
                        <label for="level"><input type="radio" name="level" value="1" <%if (rec.getVisibility() == 1)
            {
                out.println(chk);
            }%> />&nbsp;Sólo los miembros</label>
                    </p>
                    <%-- <p>
                        <label for="level"><input type="radio" name="level" value="3" <%if (rec.getVisibility() == 3)
            {
                out.println(chk);
            }%> />&nbsp;Sólo yo</label>
                    </p> --%>
                </div>
            </fieldset>

            <%
            SWBResourceURL back = paramRequest.getRenderUrl().setParameter("act", "detail");
            back.setParameter("uri", uri);
            back.setParameter("day", request.getParameter("day"));
            back.setParameter("month", request.getParameter("month"));
            back.setParameter("year", request.getParameter("year"));
            %>

        </div>
        <input type="hidden" name="uri" value="<%=rec.getURI()%>"/>
        <input type="hidden" name="act" value="edit"/>
    </form>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
</div>
<div class="columnaCentro">

</div>
<script type="text/javascript">
    var img = document.getElementById('img_<%=rec.getId()%>');
    if( img.width>img.height && img.width>350) {
        img.width = 350;
        img.height = 270;
    }else {
        if(img.height>270) {
            img.width = 270;
            img.height = 350;
        }
    }
</script>