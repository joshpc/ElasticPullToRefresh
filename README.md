# ElasticPullToRefresh

ElasticPullToRefresh is a very simple and slightly customizable pull to refresh control that has a spinner.

![spinner](https://dl.dropboxusercontent.com/u/1512544/Exp/pullToRefresh.gif)

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

