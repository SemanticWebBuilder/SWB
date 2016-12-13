<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.platform.*"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%!

public int calcularEdad(java.util.Calendar fechaNaci, java.util.Calendar fechaAlta){

        int diff_año =fechaAlta.get(Calendar.YEAR)-
        fechaNaci.get(Calendar.YEAR);
        int diff_mes = fechaAlta.get(Calendar.MONTH)- fechaNaci.get(Calendar.MONTH);
        int diff_dia = fechaAlta.get(Calendar.DATE)-fechaNaci.get(Calendar.DATE);
        if(diff_mes<0 ||(diff_mes==0 && diff_dia<0)){
            diff_año =diff_año-1;
        }
        return diff_año;
    }

%>

<%
            String registryPath = paramRequest.getWebPage().getWebSite().getWebPage("Registro_de_Usuarios").getUrl();
            String perfilPath = paramRequest.getWebPage().getWebSite().getWebPage("perfil").getUrl();
            HashMap<String, SemanticProperty> mapa = new HashMap();
            Iterator<SemanticProperty> list = org.semanticwb.SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass("http://www.semanticwebbuilder.org/swb4/community#_ExtendedAttributes").listProperties();
            while (list.hasNext())
            {
                SemanticProperty sp = list.next();
                mapa.put(sp.getName(), sp);
            }
            boolean isStrategy = false;
            if (paramRequest.getCallMethod() == paramRequest.Call_STRATEGY)
            {
                isStrategy = true;
            }


            boolean areFriends = false;
            SWBResourceURL urlAction = paramRequest.getActionUrl();
            WebPage wpage = paramRequest.getWebPage();
            User owner = paramRequest.getUser();
            User user = owner;
            if (!isStrategy && !user.isRegistered() && (request.getParameter("user") == null || request.getParameter("user").equals("")))
            {
%>
<script type="text/javascript">
    window.location.href='<%=wpage.getWebSite().getHomePage().getUrl()%>';
</script>
<%
            }

            if (request.getParameter("user") != null && !request.getParameter("user").equals(user.getURI()))
            {
                SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                user = (User) semObj.createGenericInstance();
            }


            if (request.getParameter("changePhoto") != null && request.getParameter("changePhoto").equals("1") && !isStrategy)
            {
%>
<script type="text/javascript">
    var uploads_in_progress = 0;

    function beginAsyncUpload(ul,sid) {
        ul.form.submit();
        uploads_in_progress = uploads_in_progress + 1;
        var pb = document.getElementById(ul.name + "_progress");
        pb.parentNode.style.display='block';
        new ProgressTracker(sid,{
            progressBar: pb,
            onComplete: function() {
                var inp_id = pb.id.replace("_progress","");
                uploads_in_progress = uploads_in_progress - 1;
                var inp = document.getElementById(inp_id);
                if(inp) {
                    inp.value = sid;
                }
                pb.parentNode.style.display='none';
                document.location="<%=perfilPath%>";
            },
            onFailure: function(msg) {
                pb.parentNode.style.display='none';
                alert(msg);
                uploads_in_progress = uploads_in_progress - 1;
            },
            url: '<%=registryPath%>/_rid/46/_mto/3/_mod/help'
        });
    }

</script>
<form id="fupload" name="fupload" enctype="multipart/form-data" class="swbform" dojoType="dijit.form.Form"
      action="<%=registryPath%>/_aid/46/_mto/3/_act/upload"
      method="post" target="pictureTransferFrame" >
    <fieldset>
        <legend>Cambiar fotograf&iacute;a de perfil</legend>
        <br/><br/>
        <table>
            <tr><td width="80px" align="right"><label for="picture">Fotograf&iacute;a &nbsp;</label></td>
                <td><iframe id="pictureTransferFrame" name="pictureTransferFrame" src="" style="display:none" ></iframe>
                    <input type="file" name="picture" onchange="beginAsyncUpload(this,'picture');" size="30"/>
                    <div class="progresscontainer" style="display: none;"><div class="progressbar" id="picture_progress"></div></div>
                </td></tr>
            <tr><td colspan="2" align="center"><br/><br/>
                    <!-- <input type="submit" value="enviar"> -->
                    <br/>
                    <div class="editarInfo">
                        <p><a href="javascript:enviar();">Cambiar imagen</a></p>
                    </div>
                    <div class="editarInfo">
                        <p><a href="javascript:window.location.href='<%=wpage.getUrl()%>';">Cancelar</a></p>
                    </div>
                    <script type="text/javascript">
                        function enviar()
                        {
                            document.fupload.submit();
                            window.location.href='<%=wpage.getUrl()%>';
                        }
                    </script>

                </td></tr>
        </table>
    </fieldset>
</form>
<%
            }
            else
            {


                if (owner.getURI() != null && !owner.getURI().equals(user.getURI()) && Friendship.areFriends(owner, user, paramRequest.getWebPage().getWebSite()))
                {
                    areFriends = true;
                }

                if (isStrategy)
                {

                    if (areFriends)
                    { //Si el usuario que esta en session(owner) es diferente que el que vino por parametro (user)
                        urlAction.setAction("remFriendRelship");
                        urlAction.setParameter("user", user.getURI());
%>
<p class="addOn"><a href="<%=urlAction%>">Eliminar como amigo</a></p>
<%
                    }
                    else if (user != null && owner != null && !owner.getURI().equals(user.getURI()) && !FriendshipProspect.findFriendProspectedByRequester(owner, user, wpage.getWebSite()))
                    {
                        urlAction.setAction("addFriendRelship");
                        urlAction.setParameter("user", user.getURI());
%>
<p class="addOn"><a href="<%=urlAction%>">Agregar como amigo</a></p>
<%
                    }
                    if (!owner.getURI().equals(user.getURI()))
                    {
%>
<p class="addOn"><a href="<%=perfilPath%>">Mi perfil</a></p>
<%
                    }
                }
                else
                {

                    String email = "", age = "", sex = "", userStatus = "", userInterest = "", userHobbies = "";
                    if (user.getEmail() != null && !user.getEmail().trim().equals(""))
                    {
                        email = user.getEmail();
                    }
                    if (user.getExtendedAttribute(mapa.get("userBirthDate")) != null)
                    {
                        age = "" + user.getExtendedAttribute(mapa.get("userBirthDate"));
                    }
                    if (user.getExtendedAttribute(mapa.get("userSex")) != null)
                    {
                        sex = "" + user.getExtendedAttribute(mapa.get("userSex"));
                    }
                    if (user.getExtendedAttribute(mapa.get("userStatus")) != null)
                    {
                        userStatus = "" + user.getExtendedAttribute(mapa.get("userStatus"));
                    }
                    if (user.getExtendedAttribute(mapa.get("userInterest")) != null)
                    {
                        userInterest = "" + user.getExtendedAttribute(mapa.get("userInterest"));
                    }
                    if (user.getExtendedAttribute(mapa.get("userHobbies")) != null)
                    {
                        userHobbies = "" + user.getExtendedAttribute(mapa.get("userHobbies"));
                    }
                    /*if (user.getExtendedAttribute(mapa.get("userInciso")) != null)
                    {
                    userInciso = "" + user.getExtendedAttribute(mapa.get("userInciso"));
                    }*/
                    if (sex.equalsIgnoreCase("male"))
                    {
                        sex = "Masculino";
                    }
                    else if (sex.equalsIgnoreCase("female"))
                    {
                        sex = "Femenino";
                    }
                    else
                    {
                        sex = "";
                    }
                    if (age == null)
                    {
                        age = "";
                    }
                    if (!age.equals(""))
                    {
                        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                        Date date = df.parse(age);
                        java.util.Calendar cal1 = java.util.Calendar.getInstance();
                        cal1.setTime(date);

                        java.util.Calendar cal2 = java.util.Calendar.getInstance();
                        cal2.setTime(new Date(System.currentTimeMillis()));
                        age = "" + calcularEdad(cal1, cal2);
                    }
                    if (userStatus == null)
                    {
                        userStatus = "";
                    }
                    if (userStatus.equals("single"))
                    {
                        userStatus = "Soltero";
                    }
                    else if (userStatus.equals("married"))
                    {
                        userStatus = "Casado";
                    }
                    else if (userStatus.equals("separated"))
                    {
                        userStatus = "Divorciado";
                    }
                    else if (userStatus.equals("widow"))
                    {
                        userStatus = "Viudo";
                    }
                    if (age.toString().equals("0") || age.toString().equals(""))
                    {
                        age = "No indicó el usuario";
                    }

%>


<h2>Resumen</h2>
<%
                    if (owner == user)
                    {
%>

<a class="editar" href="<%=registryPath%>" >[editar]</a>
<%
                    }
%>
<div class="resumenText">
    <p><span class="itemTitle">Nombre:</span>&nbsp;<%=user.getFullName()%></p>
    <p><span class="itemTitle">Edad:</span> &nbsp;<%=age%></p>
    <p><span class="itemTitle">Sexo:</span> <%=sex%></p>
    <%

                    if (owner == user || areFriends)
                    { //Agregar datos privados (email, s fotos, etc)
    %>
    <%
                        if (user.getEmail() != null && !user.getEmail().trim().equals(""))
                        {
    %>
    <p><span class="itemTitle">E-mail:</span>&nbsp;<a href="mailto:<%=email%>"><%=email%></a></p>
    <%
                        }
    %>


    <p><span class="itemTitle">Estado Civil:</span> <%=userStatus%></p>


    <h2>Intereses</h2>
    <p><%=userInterest%></p>
    <h2>Pasatiempos</h2>
    <p><%=userHobbies%></p>
    <%-- <h2>Inciso</h2>
    <p><%=userInciso%></p> --%>
    <%
                    }
    %>
</div>
<%
                }

            }
%>
