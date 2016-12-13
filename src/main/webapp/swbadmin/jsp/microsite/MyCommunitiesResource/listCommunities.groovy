/**
 * SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración,
 * colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de
 * información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes
 * fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y
 * procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación
 * para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite.
 *
 * INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’),
 * en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición;
 * aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software,
 * todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización
 * del SemanticWebBuilder 4.0.
 *
 * INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita,
 * siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar
 * de la misma.
 *
 * Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente
 * dirección electrónica:
 *  http://www.semanticwebbuilder.org
 **/

import org.semanticwb.portal.api.SWBParamRequest
import org.semanticwb.model.User
import org.semanticwb.model.WebPage
import org.semanticwb.portal.community.Member
import org.semanticwb.portal.community.MicroSite
import org.semanticwb.SWBPortal


def paramRequest=request.getAttribute("paramRequest")
User user = paramRequest.getUser()
WebPage wpage=paramRequest.getWebPage()
Member member = Member.getMember(user,wpage)
def lista = org.semanticwb.portal.community.base.MemberBase.ClassMgr.listMemberByUser(user,wpage.getWebSite())

if(request.getParameter("user")!=null)
{
    return;
}
if(lista.hasNext()) {
    println """
    <ul id="MenuBar1" class="MenuBarHorizontal">
    <li class="selectTitle">
        <p>Mis comunidades</p>
         <ul>
    """
    lista.each(){
        Member mem_curr = it
        MicroSite mem_mcs = mem_curr.getMicroSite()
        if (null!=mem_mcs){
            def titulo = mem_mcs.getDisplayName()
            def url = mem_mcs.getUrl()
            def urlimg=SWBPortal.getWebWorkPath()+"/models/"+ paramRequest.getWebPage().getWebSiteId()  +"/css/boton_contacto.png"
            println """<li><a class="contactos_nombre" href="${url}">$titulo</a></li>"""
        }
    }
    println """</ul></li></ul>"""
}