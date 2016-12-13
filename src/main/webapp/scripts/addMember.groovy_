import org.semanticwb.model.SWBModel
import org.semanticwb.platform.SemanticProperty
import org.semanticwb.model.WebPage
import org.semanticwb.model.WebSite
import org.semanticwb.model.UserRepository
import org.semanticwb.portal.community.Member


WebSite model = org.semanticwb.model.SWBContext.getWebSite("cd")
WebPage page = model.getWebPage("MiMicro")
UserRepository ur = model.getUserRepository()
def lista = ur.listUsers()
lista.each(){

    Member mem = Member.createMember(model)
    mem.setUser(it)
    mem.setMicroSite(page)
    mem.setAccessLevel(Member.LEVEL_ADMIN)
    
}