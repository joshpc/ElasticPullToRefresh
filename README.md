# ElasticPullToRefresh

ElasticPullToRefresh is a very simple and slightly customizable pull to refresh control that has a spinner.

![Pull To Refresh](https://user-images.githubusercontent.com/128299/35554231-4d3a5924-05de-11e8-8d5a-1c7d30c4ebb6.gif)

## Usage

#### Installation
Use **CocoaPods**: `pod 'ElasticPullToRefresh'`

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

