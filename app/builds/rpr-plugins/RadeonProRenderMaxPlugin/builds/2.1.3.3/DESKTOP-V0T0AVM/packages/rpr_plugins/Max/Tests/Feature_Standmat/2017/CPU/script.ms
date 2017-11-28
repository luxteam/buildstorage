resetMaxFile #noPrompt
SetQuietMode true
-- main parameters
PASS_LIMIT = 20
RENDER_SIZE = 512

FILE_EXTENSION = ".png" -- for the renderings

res_path = "D:\\jobs_launcher_main\\tests\\packages\\rpr_plugins\\Max\\..\\..\\..\\assets\\Max\\scenes"

function createCatalog = (
    
    OUT_DIR = "D:\\jobs_launcher_main\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Feature_Standmat\\2017\\CPU\\"

    renderers.current= Radeon_ProRender()
    fr = renderers.current
    fr.renderLimit = 1
    fr.passLimit = PASS_LIMIT
    fr.renderDevice = 1

    result = "D:\\jobs_launcher_main\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Feature_Standmat\\2017\\CPU\\" + "report.json"
    a = (createFile result mode:"w")
    line = "[\n"
    format "%" line to:a

    filesToRender = #(
    "\\Standard Checker.max"
--,"\\Standard Color Correction.max",
--"\\Standard Composite.max",
--"\\Standard Dent.max",
--"\\Standard Diffuse_Specular.max",
--"\\Standard Flat Mirror.max",
--"\\Standard Fresnel.max",
--"\\Standard Glossiness.max",
--"\\Standard Gradient Ramp.max",
--"\\Standard Gradient(Radial).max",
--"\\Standard Marble.max",
--"\\Standard Mask.max",
--"\\Standard Metal.max",
--"\\Standard Mix.max",
--"\\Standard Multilayer.max",
--"\\Standard MultiLayerSpec1&2_Noise.max",
--"\\Standard Noise.max",
--"\\Standard Normal.max",
--"\\Standard OrenNayar.max",
--"\\Standard Perlin Marble.max",
--"\\Standard Phong.max",
--"\\Standard Reflect_Refract.max",
--"\\Standard Shape Map.max",
--"\\Standard Smoke.max",
--"\\Standard Speckle.max",
--"\\Standard Splat.max",
--"\\Standard Strauss.max",
--"\\Standard Stucco.max",
--"\\Standard Swirl.max",
--"\\Standard TextMap.max",
--"\\Standard Tiles.max",
--"\\Standard VectorColorMap.max",
--"\\Standard TranslucentShader.max",
--"\\Standard VectorMap.max",
--"\\Standard Waves.max",
--"\\Standard Wood.max"

    )
    
    count_file = OUT_DIR + "\\expected.json"
    t = (createFile count_file mode:"w")
    line = "[\n"
    format "%" line to:t

    
    for fi=1 to filesToRender.count do (
        assetsFile = res_path + filesToRender[fi]
        loadMaxFile assetsFile quiet:true
        local framesToRender = #(0)
        for fra in framesToRender do (
            if fi!=filesToRender.count do (
                mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\"},\n"
                format "%" mfilename to:t
            ) 
            if fi == filesToRender.count do (
                mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\"}\n"
                format "%" mfilename to:t
            )
        )
    )
    
    e_line = "]"
    format "%" e_line to:t
    flush t
    close t

    IMAGE_DIR = OUT_DIR + "\\images\\"
    makeDir IMAGE_DIR       
    
    for fi=1 to filesToRender.count do (
        assetsFile = res_path + filesToRender[fi]
        loadMaxFile assetsFile quiet:true
        fr = renderers.current
        fr.passLimit = PASS_LIMIT
        fr.renderDevice = 1
        local framesToRender = #(0)

        for fra in framesToRender do (
            mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION
            mpath = IMAGE_DIR + mfilename
            rstart = timeStamp()
            render outputwidth:RENDER_SIZE outputheight:RENDER_SIZE frame:fra outputfile:mpath vfb:true
            rend = timeStamp()
            relapsed = ((rend - rstart) / 1000.0)
            ver_max = filterString (getdir #maxroot) "\\"
            scene_json = filterString (filesToRender[fi]) "\\"
            if fi != filesToRender.count do (
                temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                format "%" temp_line to:a
            )
            if fi == filesToRender.count do(
                temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n }\n"
                format "%" temp_line to:a
            )        
        )
    )

    e_line = "]"
    format "%" e_line to:a
    flush a
    close a    
)

createCatalog()
resetMaxFile #noPrompt
quitMax #noPrompt
