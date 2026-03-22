# WIP: tmux UI 改善

## 背景

- starship と tmux のステータスライン情報が重複していた
- 参考: https://zenn.dev/layerx/articles/8c29b0367238b8 (izumin5210/dotfiles)
- リポジトリに紐づく情報は tmux 側にまとめて表示する設計に変更中

## 完了した変更

### tmux-style.sh (新規)

- tmux のスタイル設定をシェルスクリプトに分離 (`run` で呼び出し)
- Solarized Dark の色変数で統一
- セパレーター `▕` (U+2595) で各セクションを区切り
- Nerd Font アイコン使用 (フォルダ、git ブランチ、ホスト)

### _tmux.conf 変更

- スタイル関連の設定を全て削除、`run "~/.dotfiles/tmux-style.sh"` に集約
- `default-terminal` を `screen-256color` → `tmux-256color` に変更
- window list は非表示にし、代わりに pane list を status-right に表示

### bin/tmux-pane-list (新規)

- tmux status-right 用のペイン一覧表示スクリプト
- アクティブペインは明るく、非アクティブは暗く表示
- Solarized Dark の色に合わせている

### ステータスバーのレイアウト

```
左: [session名] | [フォルダ] | [git branch]
右: [pane list] | [hostname]
window list: 右寄せ (status-justify right)
```

## 残タスク

- [ ] Ubuntu 24.04 (tmux 3.4) 環境で動作確認
- [ ] tmux 3.4 の status-left-padding 等でステータスバーの高さ/余白を調整
- [ ] starship の設定 (git 情報を削り最小プロンプトにする)
- [ ] Nerd Font アイコンの表示が小さい問題 — 太字で多少改善するが限界あり、要検討
- [ ] 色味の微調整 (実機で見ながら)
- [ ] window list の扱い — 現在は非表示。複数 window 使う場合は再検討
- [ ] tmux-client-*.log が生成される問題の確認

## 参考にした設定

- izumin5210/dotfiles: `config/.config/tmux/style.tmux`
  - スタイルをシェルスクリプトに分離する構成
  - Catppuccin Frappe テーマ
  - `git info` カスタムコマンドでリポジトリ情報を表示
  - status-justify right で window list を右寄せ
