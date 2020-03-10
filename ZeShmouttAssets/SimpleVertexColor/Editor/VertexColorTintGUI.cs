using UnityEngine;
using UnityEditor;

public class VertexColorTintGUI : ShaderGUI
{
	MaterialEditor editor;
	MaterialProperty[] properties;

	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		this.editor = materialEditor;
		this.properties = properties;

		ColorPart("Base", "D", Color.grey);
		ColorPart("Red", "R", Color.red);
		ColorPart("Green", "G", Color.green);
		ColorPart("Blue", "B", Color.blue);
		ColorPart("Alpha", "A", Color.white);
	}

	void ColorPart(string partLabel, string colorLayer, Color color)
	{
		//GUIStyle centeredLabel = EditorStyles.label;
		//centeredLabel.alignment = TextAnchor.MiddleCenter;
	
		Rect baseRect = EditorGUILayout.BeginVertical();

		Rect widthRect = new Rect(baseRect.position, new Vector2(baseRect.size.x, baseRect.size.y));
		EditorGUI.DrawRect(widthRect, new Color(color.r, color.g, color.b, 0.25f));

		EditorGUILayout.BeginHorizontal();
		GUILayout.FlexibleSpace();
		GUILayout.Label(partLabel, EditorStyles.boldLabel);
		GUILayout.FlexibleSpace();
		EditorGUILayout.EndHorizontal();

		EditorGUILayout.LabelField("Color", EditorStyles.miniBoldLabel);
		EditorGUI.indentLevel++;

		string diffuseName = string.Format("_{0}Color", colorLayer);
		MaterialProperty property = FindProperty(diffuseName, properties);
		editor.ColorProperty(property, "Tint");

		string glossName = string.Format("_{0}Smoothness", colorLayer);
		MaterialProperty glossiness = FindProperty(glossName, properties);
		editor.ShaderProperty(glossiness, "Glossiness");

		string metalName = string.Format("_{0}Metallic", colorLayer);
		MaterialProperty metallic = FindProperty(metalName, properties);
		editor.ShaderProperty(metallic, "Metallic");

		EditorGUI.indentLevel--;
		EditorGUILayout.Space();


		EditorGUILayout.LabelField("Emissive", EditorStyles.miniBoldLabel);
		EditorGUI.indentLevel++;

		string emissColorName = string.Format("_{0}EmissiveColor", colorLayer);
		MaterialProperty emissiveColor = FindProperty(emissColorName, properties);
		editor.ShaderProperty(emissiveColor, "Emissive Color");

		string emissIntensityName = string.Format("_{0}EmissiveIntensity", colorLayer);
		MaterialProperty emissiveIntensity = FindProperty(emissIntensityName, properties);
		editor.ShaderProperty(emissiveIntensity, "Emissive Intensity");

		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}
}
