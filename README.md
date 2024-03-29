# Todo & Time Table App

学校で出される課題（Todo）を時間割とまとめて管理することができるアプリケーションを作成しました。


### 時間割のページの使い方
#### 時間割の追加方法
↓ メインページ

<img src="images/main_page.png" alt="メインページ" width= "32%">



週時間割のページで追加したいマスをタップすると、授業を追加することができます。授業を追加する際は授業名、教室名と色を選択します。

<img src="images/main_page.gif" alt="" width= "32%">

<br>

↓ 授業を追加した後の画面

<img src="images/time_table_ex.png" alt="" width= "32%">


#### 時間割の編集・削除方法
時間割のページで授業のアイコンを長押しすると、その授業の情報を編集・削除をすることができます。

<img src="images/class_update_page.png" alt="授業の編集画面" width= "32%">
<img src="images/class_remove_page.png" alt="授業の削除画面" width= "32%">

---

### Todoのページの使い方
#### Todoの追加方法
時間割に追加した授業のアイコンをタップすると、その授業専用のページに移動します。そのページでは画面右下のボタンを押すことで、その授業の課題（Todo）を追加することができます。

↓ 授業の専用ページとTodoを追加した後の画面

<img src="images/class_main_page.png" alt="追加前" width = "32%">
<img src="images/todo_add_page.png" alt="追加モーダル" width = "32%">
<img src="images/class_todo_page.png" alt="追加後" width = "32%">

Todoの追加には、Todoの内容、期限を設定することします。期限の設定には、次のような方法があります。
1. "今日"を選択する (時刻は当日の23時59分59秒に設定されます)
2. "明日"を選択する (時刻は翌日の23時59分59秒に設定されます)
3. "期限"を選択し、カレンダーから日付や時刻を選択する

↓ "期限"を選択したときの画面①

<img src="images/deadline.gif" alt="期限の設定1" width = "32%">

<br>

↓ "期限"を選択したときの画面②

<img src="images/deadline2.gif" alt="期限の設定2" width = "32%">

#### Todoの編集・削除方法
TodoのページでTodoのアイコンを長押しすると、そのTodoの情報を編集することができます。また、画面に追加されたTodoを右にスワイプすることでもTodoを編集することができます。
また、画面に追加されたTodoを左にスワイすると、そのTodoを削除することができます。

↓ Todoの編集・削除画面

<img src="images/todo_edit.gif" alt="Todoの編集・削除" width="32%">

#### Todoの完了・未完了の切り替え
TodoのページでTodoのアイコンをタップすると、そのTodoの完了・未完了を切り替えることができます。完了したTodoはチェックマークが表示され、Todoの内容に取り消し線が引かれます。

また、画面上部のカレンダーには、その日が締め切りのTodoがイベントマークとして表示されます。このイベントマークは、未完了のTodoは色付きで表示され、完了したTodoはグレーで表示されます。Todoを完全に削除すると、そのTodoのイベントマークも削除されます。

↓ Todoが完了したときの画面

<img src="images/todo_event.png" alt="Todo完了画面" width="32%">

---

### すべての課題管理ページの使い方
このページではTodoの編集や削除はできませんが、すべての授業のTodoを一覧で確認することができます。また、画面上部のカレンダーには、登録した授業のカラーに応じて、その日が締め切りのTodoがイベントマークとして表示されます。
さらに、締め切りを超過したTodoは、そのTodoのイベントマークが赤色で表示されます。

↓ すべての課題管理ページ

<img src="images/all_todo_page.png" alt="Todo完了画面" width="32%">

---

### 使用した技術
|カテゴリ |技術 |
|:---:|:---:|
| フロントエンド | Flutter |
| バックエンド | Shared preferences (flutter package) |
| 状態管理 | riverpod |
| デザイン | Figma |

---

### 最後に
プロジェクトをご覧いただき、ありがとうございます。
