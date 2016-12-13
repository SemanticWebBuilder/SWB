<%@page contentType="text/html"%>
<%@page import="org.w3c.dom.*,org.semanticwb.opensocial.model.*,org.semanticwb.opensocial.resources.*,java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
    StringBuilder validation=new StringBuilder();
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebSite site=paramRequest.getWebPage().getWebSite();
    SocialUser socialuser=SocialContainer.getSocialUser(user, session,site);
    Gadget gadget=(Gadget) request.getAttribute("gadget");
    String title=gadget.getDirectoryTitle(socialuser);
    if(title==null)
    {
        title=gadget.getTitle(socialuser);
    }    
    String url=gadget.getUrl();
    String description=gadget.getDescription(socialuser);
    if(description==null)
    {
        description="";
    }
    SWBResourceURL processAction=paramRequest.getActionUrl();


    SWBResourceURL add=paramRequest.getRenderUrl();
	add.setCallMethod(SWBResourceURL.Call_DIRECT);
        add.setMode(SocialContainer.Mode_LISTGADGETS);
    
%>

<style type="text/css">
    div.wrapper {
width:600px;
}
div.left_column {
width:150px;
float:left;
text-align:left;
vertical-align:middle;
}
div.content {
width:300px;
float:left;
text-align:left;
}
div.rightcolumn {
width:150px;
float:right;
text-align:center;
vertical-align:middle;
}
hr {
clear:both;
display:block;
visibility:hidden;}


</style>

<h1>
    <%=title%>
</h1>
<p>
    <%=description%>
</p>
<%
Document doc=gadget.getDocument(socialuser.getLanguage(),socialuser.getCountry());
%>



    <form name="frmedit" action="<%=processAction%>" onsubmit="validate()">
        <input type="hidden" value="<%=url%>" name="__url__">
        <%
        NodeList userPrefs=doc.getElementsByTagName("UserPref");
        for(int i=0;i<userPrefs.getLength();i++)
        {
            if(userPrefs.item(i) instanceof Element)
            {
                Element userPref=(Element)userPrefs.item(i);
                String default_value=userPref.getAttribute("default_value");                
                String name=userPref.getAttribute("name");
                String dataType="string";
                if(userPref.getAttribute("datatype")!=null && !userPref.getAttribute("datatype").equals(""))
                {
                    dataType=userPref.getAttribute("datatype");
                }
                if("hidden".equals(dataType))
                {
                    %>
                    <input type="hidden" value="<%=default_value%>" name="<%=name%>">
                    <%
                }
                if("bool".equals(dataType))
                {
                    %>
                    <input type="hidden" value="<%=default_value%>" name="<%=name%>">
                    <%
                }

            }
        }


        if(gadget.getGadgetTitle()!=null && gadget.getGadgetTitle().indexOf("__UP_")!=-1)
        {            
            String name=gadget.getGadgetTitle();
            int pos=name.indexOf("__UP_");
            if(pos!=-1)
            {
                name=name.substring(pos);
                pos=name.lastIndexOf("__");
                if(pos!=-1)
                {
                    name=name.substring(0,pos);
                }
            }
            if(name.startsWith("__UP_"))
            {
                name=name.substring(5);
            }
            boolean exists=false;
            for(String prefname : gadget.getUserPrefsNames())
            {
                if(prefname.equals(name))
                {
                    exists=true;
                    break;
                }
            }
            if(!exists)
            {
                validation.append("\r\nif(document.frmedit.");
                validation.append(name);
                validation.append(".value==''){\r\n");
                validation.append("alert('El valor para ");
                validation.append("Título");
                validation.append(" es obligatorio');\r\n");
                validation.append("document.frmedit.");
                validation.append(name);
                validation.append(".focus();\r\n");
                validation.append("\r\nreturn false;");
                validation.append("\r\n}\r\n");
                %>
                    <div class="wrapper">
                    <div class="left_column">
                    Título:
                    </div>
                    <div class="content">
                        <input type="text" size="40" value="<%=gadget.getGadgetTitle()%>" name="<%=name%>">
                    </div><hr/></div>
                <%
            }
        }

        NodeList locales=doc.getElementsByTagName("Locale");
        if(locales.getLength()>0)
        {

        %>
        <%-- <div class="wrapper">
<div class="left_column">
Lenguaje:
</div>
<div class="content">
<select name="__lang__">
    <%
    
    for(int i=0;i<locales.getLength();i++)
    {
        if(locales.item(i) instanceof Element)
        {
            Element elocale=(Element)locales.item(i);
            String lang=elocale.getAttribute("lang");
            if(lang!=null && !lang.equals(""))
            {
                int pos=lang.indexOf("-");
                if(pos!=-1)
                {
                    lang=lang.substring(0,pos);
                }
                Locale locale=new Locale(lang);
                String title_lang=locale.getDisplayLanguage().toUpperCase();
                %>
                <option value="<%=lang%>"><%=title_lang%></option>
                <%
            }
        }
    }
    %>
    </select>
</div>
    <hr/>
</div>


--%>
    
   
<%
    }
    
    userPrefs=doc.getElementsByTagName("UserPref");
    for(int i=0;i<userPrefs.getLength();i++)
    {
        if(userPrefs.item(i) instanceof Element)
        {
            Element userPref=(Element)userPrefs.item(i);            
            String dataType="string";
            if(userPref.getAttribute("datatype")!=null && !userPref.getAttribute("datatype").equals(""))
            {
                dataType=userPref.getAttribute("datatype");
            }
            String name=userPref.getAttribute("name");
            String default_value=userPref.getAttribute("default_value");
            if(default_value==null)
            {
                default_value="";
            }
            String displayName=userPref.getAttribute("display_name");
            boolean required=false;
            String srequired=userPref.getAttribute("required");
            if("true".equalsIgnoreCase(srequired))
            {
                required=true;
            }            
            if(displayName==null || displayName.equals(""))
            {
                displayName=name;
            }
            if("bool".equals(dataType))
            {
                String checked="";
                if("true".equalsIgnoreCase(default_value))
                {
                    checked="checked";
                }
                %>
                <div class="wrapper">
                <div class="left_column">
                <%=displayName%>:
                </div>
                <div class="content">
                    <input <%=checked%> type="checkbox" onclick="changeRadio('<%=name%>')" size="40" value="<%=default_value%>" name="_<%=name%>">
                </div><hr/></div>

                <%
            }
            if("string".equals(dataType))
            {
                if(required)
                {
                    validation.append("\r\nif(document.frmedit.");
                    validation.append(name);
                    validation.append(".value==''){\r\n");
                    validation.append("alert('El valor para ");
                    validation.append(displayName);
                    validation.append(" es obligatorio');\r\n");
                    validation.append("document.frmedit.");
                    validation.append(name);
                    validation.append(".focus();\r\n");
                    validation.append("\r\nreturn false;");
                    validation.append("\r\n}\r\n");
                }
                %>
                <div class="wrapper">
                <div class="left_column">
                <%=displayName%>:
                </div>
                <div class="content">
                    <input type="text" size="40" value="<%=default_value%>" name="<%=name%>">
                </div><hr/></div>

                <%
            }   
            if("number".equals(dataType))
            {
                if(required)
                {
                    validation.append("\r\nvar _number=document.frmedit.");
                    validation.append(name);
                    validation.append(".value;\r\n");
                    validation.append("\r\nif(_number==''){\r\n");
                    validation.append("alert('El valor para ");
                    validation.append(displayName);
                    validation.append(" es obligatorio');\r\n");
                    validation.append("document.frmedit.");
                    validation.append(name);
                    validation.append(".focus();\r\n");
                    validation.append("\r\nreturn false;");
                    validation.append("if(validarNumero(_number)=='NaN'){\r\n");
                    validation.append("document.frmedit.");
                    validation.append(name);
                    validation.append(".focus();\r\n");
                    validation.append("alert('El valor para ");
                    validation.append(displayName);
                    validation.append(" debe ser un número');\r\n");
                    validation.append("return false;\r\n");
                    validation.append("}\r\n");
                    validation.append("\r\n}\r\n");
                }
                %>
                <div class="wrapper">
                <div class="left_column">
                <%=displayName%>:
                </div>
                <div class="content">
                    <input type="text" size="8" value="<%=default_value%>" name="<%=name%>">
                </div><hr/></div>

                <%
            }
            if("list".equals(dataType))
            {
                if(required)
                {
                    validation.append("\r\nif(document.frmedit.");
                    validation.append(name);
                    validation.append(".value==''){\r\n");
                    validation.append("alert('El valor para ");
                    validation.append(displayName);
                    validation.append(" es obligatorio');\r\n");
                    validation.append("document.frmedit.");
                    validation.append(name);
                    validation.append(".focus();\r\n");
                    validation.append("\r\nreturn false;");
                    validation.append("\r\n}\r\n");
                }
                StringTokenizer st=new StringTokenizer(default_value,"|");
                int rows=st.countTokens();
                %>
                <div class="wrapper">
                <div class="left_column">
                    <%=displayName%>
                </div>
                <div class="content">
                    <textarea cols="40" rows="<%=rows%>" readonly name="<%=name%>"><%
                while(st.hasMoreTokens())
                {
                    String value=st.nextToken()+"\r\n";
                    %><%=value%><%
                }
                %></textarea>
                </div><hr/></div>
                <%
            }
            if("enum".equals(dataType))
            {
                
                %>
                <div class="wrapper">
                <div class="left_column">
                    <%=displayName%>
                </div>
                <div class="content">
                <select name="<%=name%>">
                    <%
                        NodeList enumValues=userPref.getElementsByTagName("EnumValue");
                        for(int j=0;j<enumValues.getLength();j++)
                        {
                            Element enumValue=(Element)enumValues.item(j);
                            String value=enumValue.getAttribute("value");
                            String dp=enumValue.getAttribute("display_value");
                            String selected="";
                            if(default_value.equals(value))
                            {
                                selected="selected";
                            }
                            %>
                            <option <%=selected%>  value="<%=value%>"><%=dp%></option>
                            <%
                        }
                    %>
                </select></div><hr/></div>
                <%
            }
        }
    }
    
%>
<div class="wrapper">
    <div class="left_column">
        <input id="add" type="submit" name="add" value="Agregar">
    </div>
    <div class="content">
        <input id="cancel" type="button" onclick="closeWindow();" name="cancel" value="cancelar">
    </div>
</div>
</form>
<br>
<br>
<br>

<script type="text/javascript">
    function closeWindow()
    {
        this.location='<%=add%>';
    }
    function validateFields()
    {
        <%=validation%>
        return true;
    }
    function validate()
    {
        var add=document.getElementById("add");
        var cancel=document.getElementById("cancel");
        if(add)
        {
            add.disabled=true;
            cancel.disabled=true;
        }
        if(!validateFields())
        {
            if(add)
            {
                add.disabled=false;
                cancel.disabled=false;
            }
        }
    }
    function changeRadio(radioname)
    {
        var checked=document.frmedit[radioname].checked;
        if(checked)
        {
            document.frmedit[radioname].value='true';
        }
        else
        {
            document.frmedit[radioname].value='false';
        }
    }
    function validarNumero(c_numero)
    {

       if (c_numero.length == 0)
       {
           return "NaN";
       }
       else
       {

           for (i = 0; i < c_numero.length; i++)
           {
              if (!((c_numero.charAt(i) >= "0") && (c_numero.charAt(i) <= "9")))
              return "NaN";
           }
           return c_numero;
       }
    }
</script>