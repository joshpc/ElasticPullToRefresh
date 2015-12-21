# ElasticPullToRefresh

ElasticPullToRefresh is a very simple pull to refresh control that has a spinner.

## Usage

#### Installation
Use **Cocoapods**: `pod 'ElasticPullToRefresh'`

#### Code Changes
Import the module where necessary, `import ElasticPullToRefresh`

Use the `ElasticPullToRefresh` wrapper to wrap your `UIScrollView` or `UITableView` (or anything else that scrolls. Do not manually add that `UIScrollView` or `UITableView` to the view hiearchy. Add the `ElasticPullToRefresh` wrapper instead.

```
override func loadView() {
  let tableView = UITableView()
  let wrapper = ElasticPullToRefresh(scrollView: tableView)
  view = wrapper
}
```

Set a `didPullToRefresh` block. Use this to trigger your downloads. When you're done, call `didFinishRefreshing()`. That's it!

```
wrapper.didPullToRefresh = {
  downloadData()
  ...
  //call when done loading
  wrapper.didFinishRefreshing()
}
```

