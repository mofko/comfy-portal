# Comfy Portal: актуальная карта установки

Этот документ описывает каталог, который сейчас использует Comfy Portal. Он не удаляет существующие `ComfyUI/models` или `custom_nodes`: установщик создаёт только отсутствующие папки и докачивает только отсутствующие компоненты.

## Основной путь

1. Выберите или установите Portable ComfyUI.
2. Установите ComfyUI Manager.
3. Выберите модели карточками. Одна карточка — одна модель, даже когда ей нужно несколько файлов.
4. Установите ноды для воркфлоу.
5. Запустите ComfyUI и проверьте `http://127.0.0.1:8188/system_stats`.
6. Поднимите LocalTunnel из Comfy Portal; публичный адрес нужно проверять через `PUBLIC_URL/system_stats`.

## Модели

Для Civitai/civitai.red Comfy Portal получает настоящее имя файла из `Content-Disposition` или редиректа во время установки. Не переименовывайте такие файлы в ID модели или `download`.

| Модель | Компонент | Папка | URL |
|---|---|---|---|
| xxxRay DMD2 | Checkpoint | `ComfyUI/models/checkpoints` | `https://civitai.red/api/download/models/1624818?type=Model&format=SafeTensor&size=full&fp=fp16` |
| MiaoMiao Harem | UNET | `ComfyUI/models/unet` | `https://civitai.red/api/download/models/3248362?fileId=3131298` |
| MiaoMiao Harem | Text Encoder | `ComfyUI/models/text_encoders` | `https://civitai.red/api/download/models/3248362?fileId=3131293` |
| MiaoMiao Harem (Anime Coloring) | UNET | `ComfyUI/models/unet` | `https://civitai.red/api/download/models/3203207?fileId=3084585` |
| MiaoMiao Harem (Anime Coloring) | Text Encoder | `ComfyUI/models/text_encoders` | `https://civitai.red/api/download/models/3203207?fileId=3084578` |
| Krea 2 LUSTIFY | UNET | `ComfyUI/models/unet` | `https://civitai.red/api/download/models/3112728?fileId=3002352` |
| Krea 2 LUSTIFY | VAE | `ComfyUI/models/vae` | `https://huggingface.co/OreX/Models/resolve/main/WAN/wan_2.1_vae.safetensors` |
| Krea 2 LUSTIFY | Text Encoder | `ComfyUI/models/text_encoders` | `https://huggingface.co/Comfy-Org/Qwen3-VL/resolve/main/text_encoders/qwen3vl_4b_fp8_scaled.safetensors` |
| Nova Anime XL | Checkpoint | `ComfyUI/models/checkpoints` | `https://civitai.red/api/download/models/2940478?fileId=2819621` |

Статусы модели:

- **Не установлена** — нет ни одного обязательного компонента.
- **Частично установлена** — есть только часть компонентов; повторная установка докачает остаток.
- **Установлена** — все обязательные компоненты найдены.

## Custom nodes

Устанавливаются следующие ноды (репозитории и папки — единственный источник истины в `REQUIRED_NODE_SPECS` приложения):

```text
ComfyUI Impact Pack                 ComfyUI-Custom-Scripts
rgthree-comfy                       ComfyUI-Easy-Use
ComfyUI_UltimateSDUpscale           ComfyUI Impact Subpack
CG Use Everywhere                   Save Image with Generation Metadata
Various ComfyUI Nodes by Type       CRT-Nodes
ComfyUI-Chibi-Nodes                 ComfyUI_essentials
Comfyroll Studio                    ComfyUI ControlNet Aux
ComfyUI LayerStyle                  ComfyUI-KJNodes
ComfyUI-SeedVR2 VideoUpscaler       ComfyUI-RMBG
ComfyUI-Crystools                   ComfyUI-Florence2
ComfyUI-ReActor                     ComfyUI-QwenVL
ComfyUI_Fill-Nodes                  Derfuu ComfyUI ModdedNodes
facerestore_cf                      ComfyUI-mxToolkit
ComfyUI post processing nodes       virtuoso-nodes
ComfyUI QualityOfLifeSuit Omar92    ComfyUI WD14 Tagger
ComfyUI Advanced ControlNet         ComfyUI tinyterraNodes
ComfyUI DepthAnythingV2             ComfyUI Mira
Comfy Image Saver                   ComfyUI Image Saver
ComfyUI-FBCNN                       ComfyUI Lora Manager
ComfyUI PIX Nvidia RTX Deblur Denoise
comfyui-gps-supplements             ComfyUI JPS Nodes
ComfyUI EasyColorCorrector          ComfyMath
ComfyUI Inspire Pack                ComfyUI Detail Daemon
RES4LYF                             WAS Node Suite
ComfyUI-GGUF                        ComfyUI-iTools
ControlAltAI-Nodes                  ComfyUI-Inpaint-CropAndStitch
ComfyUI-VideoHelperSuite            ComfyUI-TiledDiffusion
ComfyUI-WanVideoWrapper             ComfyUI-WanAnimatePreprocess
ComfyUI-Easy-Sam3                   ComfyUI-SCAIL-Pose
ComfyUI-MelBandRoFormer             ComfyUI-Qwen-TTS
ComfyUI-FishAudioS2                 ComfyUI-Pixaroma
```

`ComfyUI_Swwan` намеренно не входит в список. Уже установленная пользовательская папка этой ноды не удаляется.

## Проверка после установки

```powershell
Invoke-RestMethod http://127.0.0.1:8188/system_stats
Invoke-RestMethod http://127.0.0.1:8188/queue
```

Проверьте, что существуют нужные папки:

```text
ComfyUI/models/unet
ComfyUI/models/text_encoders
ComfyUI/models/vae
ComfyUI/models/checkpoints
```

При ошибке Civitai сохраните показанную приложением ссылку и папку, скачайте файл вручную в ту же папку и снова откройте страницу установки. Не очищайте `ComfyUI/models` для повторной попытки.

## Сборка Windows portable

```powershell
python .\setup_cxfreeze.py build_exe --build-exe .\cxfreeze_dist
```

Запуск: `cxfreeze_dist\Comfy Portal.exe`.
