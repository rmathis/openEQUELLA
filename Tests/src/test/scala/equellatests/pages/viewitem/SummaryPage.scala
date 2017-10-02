package equellatests.pages.viewitem

import com.tle.webtests.framework.PageContext
import equellatests.pages.BrowserPage
import equellatests.pages.wizard.WizardPageTab
import org.openqa.selenium.By

class SummaryPage(val ctx: PageContext) extends BrowserPage {

  override def pageBy: By = By.xpath("//div[@class='itemsummary-layout']")

  private def getActionBy(actionText: String) = By.xpath("//a[normalize-space(text())=" + quoteXPath(actionText) + "]")

  private def clickAction(action: String) : Unit = driver.findElement(getActionBy(action)).click()

  def edit() : WizardPageTab = {
    clickAction("Edit this version")
    new WizardPageTab(ctx, 0).get()
  }
}
