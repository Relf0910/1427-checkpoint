# Trigger Keywords — 1427-checkpoint

> **Language-agnostic intent detection is PRIMARY. Keyword lists are fallback evidence.**
> Every mutating intent triggers regardless of the human language used.

## 0 — Universal Intent Gate (PRIMARY — LANGUAGE-AGNOSTIC) — HARD STOP

If the user's **intent** is to mutate code, files, configuration, systems,
or version-control state, display the framework and wait for approval —
**even when no keyword below appears verbatim.**

A mutating intent is any request whose expected effect is one of:

- create / add / generate / scaffold / initialize
- modify / edit / change / update / replace / refactor / restructure / format / patch
- delete / remove / purge / clean / drop / uninstall
- fix / repair / correct / resolve (when the fix implies a file or system change)
- install / setup / configure / deploy / migrate / upgrade / downgrade / rollback
- commit / push / pull / merge / revert / reset / branch / checkout (with side effects)
- database write / schema change / permission change
- any `chmod` / `mkdir` / `rm` / `cp` / `mv` / `Bash` / `PowerShell` with side effects

**Rule:** If the intent would require calling `Edit`, `Write`, `Bash`,
`PowerShell`, `NotebookEdit`, or any side-effect API — it triggers.
Language does not matter. Indonesian, Malay, Arabic, Chinese, Japanese,
Spanish, or any other language — same gate.

```
User says "hapus semua sesi"  → intent = delete → TRIGGER (even though "delete" absent)
User says "buatkan fitur login" → intent = create → TRIGGER
User says "请删除测试文件"        → intent = delete → TRIGGER
User says "إنشاء ملف جديد"       → intent = create → TRIGGER
User says "バグを修正して"        → intent = fix    → TRIGGER
```

## 1 — Keyword Fallback Lists (HARD STOP — exact or substring match)

Use these lists only as **additional evidence** when intent detection is
uncertain. A match in ANY language triggers. The canonical action is
shown in brackets.

### Create / Add — [CREATE]

`create`, `add`, `make`, `write`, `new`, `generate`, `build`, `init`,
`scaffold`, `initialize`, `create table`

`buat`, `bikin`, `buatkan`, `bikinkan`, `cipta`, `ciptakan`, `tambah`, `tambahkan`, `menambahkan`,
`bina`, `hasilkan`, `tulis`, `scaffold`

`padam` is delete — not here. Malay `cipta`, `bina`, `tambah` count.

`إنشاء`, `أضف`, `أنشئ`, `新建`, `创建`, `添加`, `生成`, `作成`, `追加`, `생성`, `추가`,
`créer`, `ajouter`, `crear`, `añadir`, `erstellen`, `hinzufügen`

### Modify — [MODIFY]

`edit`, `modify`, `change`, `update`, `replace`, `patch`, `refactor`,
`restructure`, `format`, `alter table`

`ubah`, `ubahkan`, `mengubah`, `ganti`, `gantikan`, `mengganti`, `sunting`, `edit`,
`perbarui`, `memperbarui`, `modifikasi`, `refaktor`, `restruktur`, `format`, `tukar`, `pinda`

`تعديل`, `غيّر`, `حدّث`, `修改`, `更新`, `替换`, `重构`, `変更`, `更新`, `修正`,
`modifier`, `cambiar`, `modificar`, `ändern`, `bearbeiten`

### Delete / Remove — [DELETE] — always flag [HIGH] when confirmed

`delete`, `remove`, `drop`, `trash`, `uninstall`, `purge`, `clean`,
`clear`, `rm`, `drop table`

`hapus`, `hapuskan`, `menghapus`, `buang`, `buangkan`, `membuang`, `hilangkan`, `padam`, `memadam`,
`bersihkan`, `membersihkan`, `kosongkan`, `singkirkan`, `uninstall`, `bongkar`

`احذف`, `إزالة`, `حذف`, `删除`, `移除`, `清除`, `清空`, `削除`, `除去`, `삭제`, `제거`,
`supprimer`, `eliminar`, `löschen`, `entfernen`

### Fix / Repair — [MODIFY] (triggers when a file/system change is implied)

`fix`, `repair`, `heal`, `correct`, `resolve`, `patch`, `hotfix`,
`amend`, `mend`

`perbaiki`, `memperbaiki`, `betulkan`, `membetulkan`, `baiki`, `membaiki`, `koreksi`, `koreksikan`,
`bereskan`, `membereskan`, `atasi`, `mengatasi`, `benahi`, `membenahi`

`إصلاح`, `أصلح`, `صحح`, `修复`, `修正`, `修復`, `修补`, `修正する`, `修復する`, `수정`, `고치다`,
`corriger`, `réparer`, `corregir`, `reparar`, `reparieren`, `korrigieren`

### System / Config — [MODIFY or HIGH]

`install`, `setup`, `configure`, `deploy`, `migrate`, `upgrade`,
`downgrade`, `rollback`, `chmod`, `mkdir`, `rm`, `cp`, `mv`, `grant`, `revoke`

`pasang`, `memasang`, `instal`, `pasangkan`, `setup`, `konfigurasi`, `konfigurasikan`, `atur`,
`deploy`, `migrasi`, `migrasikan`, `tingkatkan`, `turunkan`, `rollback`, `kembalikan`

`ثبّت`, `إعداد`, `تكوين`, `نشر`, `安装`, `配置`, `部署`, `迁移`, `インストール`, `設定`, `配置`,
`installer`, `configurer`, `instalar`, `configurar`, `installieren`, `konfigurieren`

### Version Control — [HIGH when targeting main/master]

`push`, `pull`, `merge`, `commit`, `revert`, `reset`, `branch`,
`checkout`, `rebase`, `cherry-pick`, `stash`

`unggah`, `dorong`, `tarik`, `gabung`, `komit`, `komitmen`, `kembalikan`, `atur ulang`,
`cabang`, `pindah cabang`, `checkout`

`ادفع`, `اسحب`, `دمج`, `التزام`, `推送`, `拉取`, `合并`, `提交`, `プッシュ`, `プル`, `マージ`, `コミット`,
`pousser`, `fusionner`, `hacer push`, `fusionar`, `pushen`, `mergen`

### Database — [HIGH]

`insert`, `update`, `delete from`, `drop table`, `create table`,
`alter table`, `grant`, `revoke`, `truncate`

`masukkan`, `sisipkan`, `perbarui`, `hapus dari`, `buat tabel`, `ubah tabel`

`أدخل`, `إدراج`, `插入`, `更新`, `削除`, `挿入`

## SOFT STOP — Display framework, but execution may continue after review

Any language equivalent of:

`plan`, `discuss`, `propose`, `what if`, `should i`, `do i need`,
`analyze`, `check`, `verify`, `review`, `audit`, `assess`, `evaluate`

`rencana`, `rencanakan`, `diskusi`, `diskusikan`, `usulkan`, `bagaimana jika`, `apakah saya perlu`,
`analisis`, `periksa`, `verifikasi`, `tinjau`, `audit`, `nilai`, `kaji`, `cadangkan`

`خطة`, `ناقش`, `اقترح`, `تحليل`, `计划`, `讨论`, `提案`, `分析`, `計画`, `議論`, `提案`, `分析`

## NOT a trigger — proceed directly (all languages)

`show`, `list`, `explain`, `what is`, `who is`, `how to`, `why`,
`tell me`, `find`, `search`, `look up`, `what does`, `what are`,
`clarify`, `describe`, `define`, `compare`, `summarize`, `translate`

`tunjukkan`, `tampilkan`, `daftar`, `jelaskan`, `apa itu`, `siapa`, `bagaimana`, `mengapa`,
`beri tahu`, `cari`, `temukan`, `cari tahu`, `apa artinya`, `bandingkan`, `ringkas`, `terjemahkan`

`paparkan`, `senaraikan`, `terangkan`, `apakah`, `bagaimanakah`, `mengapakah`

`اعرض`, `اشرح`, `ما هو`, `显示`, `列出`, `解释`, `是什么`, `表示`, `一覧`, `説明`, `とは`

## Guidance

- Trigger detection is based on **intent**, not exact word matching.
  "Can you initialize the project?" triggers because `init` matches —
  and "bisakah kamu inisialisasi proyek?" triggers because intent = init.
- **Intent always wins over keywords.** If the intent is clearly mutating,
  trigger even with zero keyword hits. If intent is clearly read-only,
  do not trigger even if a keyword appears inside a code example.
- Compound phrases count: "set up and configure" triggers `setup` and `configure` —
  and "pasang dan konfigurasi" triggers the same.
- Negated forms still count if the overall request intent is to perform
  the action: "delete the test file" → trigger. "Do not delete the test file"
  → not a trigger, but still display a brief confirmation.
- Cross-language: "hapus", "padam", "删除", "削除", "احذف", "supprimer",
  "eliminar", "löschen" all map to the same [DELETE] intent — all trigger.
- When a request mixes trigger and non-trigger content, treat only the
  trigger portion as requiring a framework. The non-trigger portion can
  proceed while the framework is displayed for the trigger portion.
- **Vague mutating phrases** (`fix it`, `bereskan`, `buat jalan`, `make it work`,
  `update everything`, `semua aja`, `全部改一下`) MUST be expanded by
  Intent-to-Command Engine into explicit steps with targets before display.
  Mark uninspected targets as `[UNVERIFIED]` and flag risk `HIGH`.
