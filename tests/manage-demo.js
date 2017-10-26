const puppeteer = require('puppeteer');

(async () => {
  // const browser = await puppeteer.launch();
  const browser = await puppeteer.launch({headless: false}); // headless default is true, slow down by 50ms then add slowMo: 50
  const page = await browser.newPage();

  const domain = 'http://localhost/'
  const rpath = 'manage-demo/CustomReports/'
  const url = domain + rpath

  await page.goto('http://localhost/manage-demo/login');
  await page.type('input[name=username]', 'i2ce_admin');
  await page.type('input[name=password]', 'manage');
  await page.click('input[name="submit"]');
  await page.goto('http://localhost/manage-demo/manage');
  await page.goto('http://localhost/manage-demo/CustomReports/edit/reports')

  // cant detect failures yet. response is still 200, but page is a redirect.
  var val;
  var a = ["open_position_list", "position_list", "facility_list", "search_people"];
  for (val of a) {
    var x = await page.goto(`${url + 'generate/' + val}`)
    console.log(val + ' generate: ' + x.status);
    var y = await page.goto(`${url + 'show/' + val}`)
    console.log(val + ' show: ' + y.status);
  }

  // works but what report view is generated from staff_list? staff_directory works
  await page.goto('http://localhost/manage-demo/CustomReports/generate/staff_list')
  await page.goto('http://localhost/manage-demo/CustomReports/show/staff_directory')

  // fails
  await page.goto('http://localhost/manage-demo/CustomReports/generate/csd_facility_list')
  await page.goto('http://localhost/manage-demo/CustomReports/show/csd_facility_list')

  // fails - no cache data for the request, may not be an issue
  await page.goto('http://localhost/manage-demo/CustomReports/generate/csd_organization_list')
  await page.goto('http://localhost/manage-demo/CustomReports/show/csd_organization_list')

  await browser.close();
})();
