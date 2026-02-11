# Place in ~/.claude/skills since all tools populate from there as well as their own sources
mkdir -p ~/.claude/skills
if [ -L ~/.claude/skills/omakub-ai ]; then
    rm ~/.claude/skills/omakub-ai
fi
ln -s $OMAKUB_PATH/default/omakub-ai-skill ~/.claude/skills/omakub-ai